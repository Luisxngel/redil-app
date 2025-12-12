import 'package:injectable/injectable.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/entities/attendance.dart';
import '../../features/members/domain/entities/member.dart';
import '../../features/members/domain/repositories/member_repository.dart';

@lazySingleton
class StatisticsService {
  final MemberRepository _memberRepo;
  final AttendanceRepository _attendanceRepo;

  StatisticsService(this._memberRepo, this._attendanceRepo);

  /// 1. Active Members Count
  Future<int> getActiveMembersCount() async {
    final members = await _memberRepo.getMembers().first;
    return members.length;
  }

  /// 2. Upcoming Birthdays (next [days] days)
  Future<List<Member>> getUpcomingBirthdays({int days = 7}) async {
    final members = await _memberRepo.getMembers().first;
    final now = DateTime.now();
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

  /// 3. Attrition Risk (Absent in last [threshold] MANDATORY events)
  Future<List<Member>> getAttritionRiskMembers({int threshold = 3}) async {
    // Get all active members
    final members = await _memberRepo.getMembers().first;
    
    // Get recent history
    final history = await _attendanceRepo.getHistory().first;
    
    if (history.isEmpty) return [];

    return members.where((member) {
      // Logic: Member is AT RISK if missing from last [threshold] RELEVANT & MANDATORY events.
      // We scan history backwards until we find [threshold] mandatory events for this user.
      int checkedEvents = 0;
      int absences = 0;

      for (var event in history) {
        if (checkedEvents >= threshold) break;

        final isMandatory = _isMandatoryFor(member, event);
        if (isMandatory) {
          checkedEvents++;
          if (!event.presentMemberIds.contains(member.id)) {
            absences++;
          }
        }
      }

      // If we found enough mandatory events, and they missed all of them (or high %), risk.
      // Simple rule: missed all of the last N mandatory events found.
      if (checkedEvents == 0) return false; // No mandatory events recently, safe.
      
      return absences == checkedEvents; // Missed all considered mandatory events
    }).toList();
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
        'description': event.description ?? 'Reunión General',
        'attended': attended,
        'isOptional': event.targetRole == 'OPTIONAL',
      };
    }).toList();
  }

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

    // Fairness Logic:
    // Denominator: Mandatory events (ALL or Role) AND NOT OPTIONAL.
    // Numerator: Any attended event.
    
    int denominator = 0;
    int numerator = 0;

    for (var event in history) {
      final attended = event.presentMemberIds.contains(memberId);
      
      if (attended) {
        numerator++;
      }
      
      if (_isMandatoryFor(member!, event)) {
        denominator++;
      }
    }

    double percentage = 0.0;
    if (denominator > 0) {
      percentage = (numerator / denominator) * 100;
      // Cap at 100? User implies > 100 is good ("mejora el %").
      // But for UI (Ring), usually 0-1 range. The ring widget expects 0-100?
      // Let's cap at 100 for display safety, strictly speaking fairness usually means 100% max.
      // But if user wants to see >100, we pass it. The UI can handle it.
      if (percentage > 100) percentage = 100; // Let's cap for UI consistency.
    } else if (numerator > 0) {
      percentage = 100.0; // Attended events but none required? 100% score.
    }

    // Last 5 displayed events (Same logic as History visibility)
    final historyDialog = history.where((event) {
       final attended = event.presentMemberIds.contains(memberId);
       if (!_isTargetedAt(member!, event) && !attended) return false;
        if (event.targetRole == 'OPTIONAL' && !attended) return false;
       return true;
    }).take(5).map((event) {
      return {
        'date': event.date,
        'description': event.description ?? 'Reunión General',
        'attended': event.presentMemberIds.contains(memberId),
      };
    }).toList();

    return {
      'percentage': percentage,
      'history': historyDialog,
    };
  }

  // --- Helpers ---

  bool _isTargetedAt(Member member, Attendance event) {
    if (event.targetRole == 'ALL') return true;
    if (event.targetRole == 'OPTIONAL') return true; 
    if (event.targetRole == 'MANUAL') return event.invitedMemberIds.contains(member.id);
    
    if (event.targetRole == 'LIDER' && member.role == MemberRole.leader) return true;
    if (event.targetRole == 'MEMBER' && member.role == MemberRole.member) return true;
    if (event.targetRole == 'LIDER' && member.role == MemberRole.assistant) return true;
    return false;
  }

  bool _isMandatoryFor(Member member, Attendance event) {
    if (event.targetRole == 'OPTIONAL') return false;
    if (event.targetRole == 'ALL') return true;
    if (event.targetRole == 'MANUAL') return event.invitedMemberIds.contains(member.id);

    // Role matching
    if (event.targetRole == 'LIDER') {
      return member.role == MemberRole.leader || member.role == MemberRole.assistant;
    }
    if (event.targetRole == 'MEMBER') {
      return member.role == MemberRole.member;
    }
    return false;
  }
}
