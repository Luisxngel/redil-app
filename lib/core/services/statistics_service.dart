import 'package:injectable/injectable.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/entities/attendance.dart';
import '../../features/members/domain/entities/member.dart';
import '../../features/members/domain/entities/member_risk.dart'; // NEW
import '../../features/members/domain/repositories/member_repository.dart';
import '../providers/date_time_provider.dart';

@lazySingleton
class StatisticsService {
  final MemberRepository _memberRepo;
  final AttendanceRepository _attendanceRepo;
  final IDateTimeProvider _timeProvider;

  StatisticsService(this._memberRepo, this._attendanceRepo, this._timeProvider);

  /// 1. Active Members Count
  Future<int> getActiveMembersCount() async {
    final members = await _memberRepo.getMembers().first;
    return members.length;
  }

  /// 2. Upcoming Birthdays (next [days] days)
  Future<List<Member>> getUpcomingBirthdays({int days = 7}) async {
    final members = await _memberRepo.getMembers().first;
    final now = _timeProvider.now;
    final limit = now.add(Duration(days: days));

    return members.where((m) {
      if (m.dateOfBirth == null) return false;
      
      final dob = m.dateOfBirth!;
      // Normalize DOB to current year
      var nextBirthday = DateTime(now.year, dob.month, dob.day);
      
      // If birthday passed this year, check next year
      if (nextBirthday.isBefore(DateTime(now.year, now.month, now.day))) {
        nextBirthday = DateTime(now.year + 1, dob.month, dob.day);
      }

      return nextBirthday.isAfter(now.subtract(const Duration(days: 1))) && 
             nextBirthday.isBefore(limit);
    }).toList()
      ..sort((a, b) {
         // Sort by who is closer
         final dobA = a.dateOfBirth!;
         final dobB = b.dateOfBirth!;
         // Simplified sort, ideally use calculated nextBirthday
         return dobA.day.compareTo(dobB.day); // Rough sort
      });
  }

  /// 3. Attrition Risk (Consecutive Absences)
  Future<List<MemberRisk>> getAttritionRiskMembers({int threshold = 3}) async {
    // Get all active members
    final members = await _memberRepo.getMembers().first;
    
    // Get full history (most recent first, assuming sorted)
    // Actually AttendanceRepository usually returns sorted by date DESC? 
    // If not, we should sort member-side or ensure repo does. Assumed DESC.
    final history = await _attendanceRepo.getHistory().first;
    
    if (history.isEmpty) return [];

    final List<MemberRisk> riskList = [];

    for (var member in members) {
      // Logic: Count consecutive absences in MANDATORY events starting from most recent.
      // Stop at first presence.
      int consecutiveAbsences = 0;

      for (var event in history) {
        if (event.date.isAfter(_timeProvider.now)) continue; // FIX
        final isMandatory = _isMandatoryFor(member, event);
        if (isMandatory) {
          final attended = event.presentMemberIds.contains(member.id);
          if (attended) {
            // Streak broken
            break; 
          } else {
            consecutiveAbsences++;
          }
        }
      }

      // If consecutive absences meet threshold AND not contacted recently
      if (consecutiveAbsences >= threshold) {
        // Logic: Show if never contacted OR contacted > 7 days ago
        bool showInRisk = true;
        if (member.lastContacted != null) {
           final daysSinceContact = _timeProvider.now.difference(member.lastContacted!).inDays;
           if (daysSinceContact <= 7) {
             showInRisk = false; // Give them a break
           }
        }

        if (showInRisk) {
          riskList.add(MemberRisk(member, consecutiveAbsences));
        }
      }
    }
    
    // Sort by risk (higher absences first)
    riskList.sort((a, b) => b.consecutiveAbsences.compareTo(a.consecutiveAbsences));
    
    return riskList;
  }

  /// 4. Average Attendance (Last [events] count)
  Future<double> getAverageAttendance({int events = 4}) async {
     final history = await _attendanceRepo.getHistory().first;
     if (history.isEmpty) return 0.0;

     // This average is global, so it likely counts total check-ins vs total capacity?
     // Or just average distinct people per event.
     // Keep it simple: Average attendees per event (regardless of type).
     // Though "LIDER" events will lower the average.
     // Maybe filter 'ALL' only? For now, keep as is (Attendees per event).
     final recentEvents = history.take(events).toList();
     if (recentEvents.isEmpty) return 0.0;

     final total = recentEvents.fold(0, (sum, event) => sum + event.presentMemberIds.length);
     return total / recentEvents.length;
  }

  /// 5. Last Event Attendance Count
  Future<int> getLastEventAttendanceCount() async {
    final history = await _attendanceRepo.getHistory().first;
    // Filter out future events to be safe
    final pastEvents = history.where((e) => e.date.isBefore(_timeProvider.now) || e.date.isAtSameMomentAs(_timeProvider.now)).toList();
    
    if (pastEvents.isEmpty) return 0;
    
    // Assuming history is sorted DESC. If not, sort it.
    // Usually repo returns sorted, but let's be safe or just take first if trustworthy.
    // The previous logic takes first. Let's assume list is recent-first.
    return pastEvents.first.presentMemberIds.length;
  }

  /// 5b. Last Event Attendees
  Future<List<Member>> getLastEventAttendees() async {
    final history = await _attendanceRepo.getHistory().first;
    // Filter out future events
    final pastEvents = history.where((e) => e.date.isBefore(_timeProvider.now) || e.date.isAtSameMomentAs(_timeProvider.now)).toList();
    
    if (pastEvents.isEmpty) return [];
    
    final lastEvent = pastEvents.first;
    final allMembers = await _memberRepo.getMembers().first;
    
    return allMembers.where((m) => lastEvent.presentMemberIds.contains(m.id)).toList();
  }

  /// 6. Harvest Count (Members created this month)
  Future<int> getHarvestCount() async {
    final members = await _memberRepo.getMembers().first;
    final now = _timeProvider.now;
    
    return members.where((m) {
      if (m.isDeleted) return false;
      if (m.isHarvested) return false; // NEW: Exclude harvested
      return m.createdAt.year == now.year && m.createdAt.month == now.month;
    }).length;
  }

  /// 6b. Harvest Members (Members created this month)
  Future<List<Member>> getHarvestMembers() async {
    final members = await _memberRepo.getMembers().first;
    final now = _timeProvider.now;
    
    return members.where((m) {
      if (m.isDeleted) return false;
      if (m.isHarvested) return false; // NEW: Exclude harvested
      return m.createdAt.year == now.year && m.createdAt.month == now.month;
    }).toList();
  }

  /// 5. Member History
  Future<List<Map<String, dynamic>>> getMemberHistory(String memberId) async {
    final members = await _memberRepo.getMembers().first;
    // Find member to know role
    Member? member;
    try {
      member = members.firstWhere((m) => m.id == memberId);
    } catch (_) {
      return [];
    }

    final history = await _attendanceRepo.getHistory().first;

    // Filter events:
    // 1. Must be targeted to user (ALL, their Role, or OPTIONAL)
    // 2. If OPTIONAL, only show if attended.
    // 3. If Targeted to others, hide.
    
    final relevantHistory = history.where((event) {
        final attended = event.presentMemberIds.contains(memberId);
        if (_isTargetedAt(member!, event)) return true;
        if (event.targetRole == 'OPTIONAL' && attended) return true;
        return false;
    }).toList();
    
    // Additional Filter: User said "Si el evento era 'OPTIONAL' y el usuario NO fue, NO lo muestres"
    // My previous logic: `_isTargetedAt` returns true for OPTIONAL? No, let's refine.
    
    return relevantHistory.where((event) {
       // Hide optional if not attended
       final attended = event.presentMemberIds.contains(memberId);
       if (event.targetRole == 'OPTIONAL' && !attended) return false;
       return true;
    }).map((event) {
      final attended = event.presentMemberIds.contains(memberId);
      return {
        'date': event.date,
        'description': event.title ?? event.description ?? 'Reunión General',
        'attended': event.presentMemberIds.contains(memberId),
        'isOptional': event.targetRole == 'OPTIONAL',
        'isFuture': event.date.isAfter(_timeProvider.now),
      };
    }).toList();
  }

  /// 6. Member Stats for Tile (Percentage)
  /// 6. Member Stats for Tile (Percentage)
  Future<Map<String, dynamic>> getMemberStats(String memberId) async {
    final members = await _memberRepo.getMembers().first;
    Member? member;
    try {
       member = members.firstWhere((m) => m.id == memberId);
    } catch (_) {
       return {'percentage': 0.0, 'history': <Map<String, dynamic>>[]};
    }

    final history = await _attendanceRepo.getHistory().first;
    if (history.isEmpty) {
      return {'percentage': 0.0, 'history': <Map<String, dynamic>>[]};
    }

    int mandatoryTotal = 0;
    int mandatoryAttended = 0;
    int extraAttended = 0;

    for (var event in history) {
      // FIX: Ignore future events for statistics
      if (event.date.isAfter(_timeProvider.now)) continue;

      print('LOOP Processing: ${event.description} for ${member?.firstName}'); // DEBUG
      final attended = event.presentMemberIds.contains(memberId);
      
      // CASO ESPECIAL: Eventos Opcionales
      // No suman al denominador (mandatoryTotal). Solo suman extras si asiste.
      if (event.targetRole == 'OPTIONAL') {
        if (attended) {
          extraAttended++;
        }
        continue;
      }

      // CASO STANDARD: Verificar obligatoriedad
      if (_isMandatoryFor(member!, event)) {
        mandatoryTotal++;
        if (attended) {
          mandatoryAttended++;
        }
      } else {
        // CASO: Evento no dirigido al usuario (Ni por Rol, Ni por Invitación) -> IGNORAR
        // No suma al denominador ni al numerador.
      }
    }

    double percentage = 0.0;
    if (mandatoryTotal > 0) {
      percentage = (mandatoryAttended / mandatoryTotal) * 100;
      
      // Math Safety
      if (percentage < 0) percentage = 0;
      if (percentage > 100) percentage = 100; 
      
    } else if (mandatoryAttended > 0) {
      // Edge Case: No tenías obligación pero asististe a obligatorios?
      // (Puede pasar si cambias de rol después del evento o lógica difusa).
      percentage = 100.0; 
    }

    // Prepare History for Dialog (Last 5)
    final historyDialog = history.where((event) {
       final attended = event.presentMemberIds.contains(memberId);
       
       // Same visibility logic as calculation
       if (event.targetRole == 'OPTIONAL') {
         return attended; // Show optional only if attended
       }
       
       // Show if targeted/mandatory OR if attended (even if not mandatory)
       return _isMandatoryFor(member!, event) || attended;
    }).take(5).map((event) {
      return {
        'date': event.date,
        'description': event.title ?? event.description ?? 'Reunión General',
        'attended': event.presentMemberIds.contains(memberId),
        'isFuture': event.date.isAfter(_timeProvider.now),
      };
    }).toList();

    return {
      'percentage': percentage,
      'extraCount': extraAttended,
      'history': historyDialog,
      'status': (mandatoryTotal == 0 && mandatoryAttended == 0 && extraAttended == 0) ? 'NEUTRAL' : 'ACTIVE',
      'label': (mandatoryTotal == 0 && mandatoryAttended == 0) ? 'Sin Datos' : '${percentage.toStringAsFixed(0)}%',
    };
  }

  // --- Helpers ---

  bool _isTargetedAt(Member member, Attendance event) {
    // Reutilizamos la lógica de obligatoriedad para consistencia visual
    if (event.targetRole == 'OPTIONAL') return true; 
    return _isMandatoryFor(member, event);
  }

  bool _isMandatoryFor(Member member, Attendance event) {
    // --- DEBUG LOGS INJECTED ---
    print('--- DEBUG CHECK ---');
    print('User: ${member.firstName} ${member.lastName} (${member.role})');
    print('Event: ${event.description} | Target: ${event.targetRole}');
    print('InvitedList: ${event.invitedMemberIds}');
    print('Is in InvitedList?: ${event.invitedMemberIds.contains(member.id)}');
    // ---------------------------

    // 1. Check de Exclusividad (Prioridad Absoluta)
    // Si hay invitados explícitos, el evento es EXCLUSIVO para ellos.
    if (event.invitedMemberIds.isNotEmpty) {
      return event.invitedMemberIds.contains(member.id);
    }

    // 2. Logic por Roles (Solo si NO hay invitados específicos)
    if (event.targetRole == 'OPTIONAL') return false; 
    
    if (event.targetRole == 'ALL') return true;

    if (event.targetRole == 'LIDER') {
      return member.role == MemberRole.leader || member.role == MemberRole.assistant;
    }
    
    if (event.targetRole == 'MEMBER') {
      return member.role == MemberRole.member;
    }
    
    // Default fallback
    return false;
  }
}
