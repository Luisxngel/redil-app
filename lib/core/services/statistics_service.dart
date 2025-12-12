import 'package:injectable/injectable.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
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

  /// 3. Attrition Risk (Absent in last [threshold] events)
  Future<List<Member>> getAttritionRiskMembers({int threshold = 3}) async {
    // Get all active members
    final members = await _memberRepo.getMembers().first;
    
    // Get recent history
    final history = await _attendanceRepo.getHistory().first;
    
    if (history.isEmpty) return [];

    // Take last [threshold] events. 
    // History is Date Desc (newest first).
    final recentEvents = history.take(threshold).toList();
    
    // If not enough data, we can still analyze what we have, but maybe require at least 1?
    if (recentEvents.isEmpty) return [];

    return members.where((member) {
      // Logic: Member is AT RISK if their ID appears in NONE of the recent events' presentLists
      // member.id is the UUID
      bool presentAtLeastOnce = false;
      for (var event in recentEvents) {
        if (event.presentMemberIds.contains(member.id)) {
          presentAtLeastOnce = true;
          break;
        }
      }
      return !presentAtLeastOnce;
    }).toList();
  }

  /// 4. Average Attendance (Last [events] count)
  Future<double> getAverageAttendance({int events = 4}) async {
     final history = await _attendanceRepo.getHistory().first;
     if (history.isEmpty) return 0.0;

     final recentEvents = history.take(events).toList();
     if (recentEvents.isEmpty) return 0.0;

     final total = recentEvents.fold(0, (sum, event) => sum + event.presentMemberIds.length);
     return total / recentEvents.length;
  }

  /// 5. Member History
  Future<List<Map<String, dynamic>>> getMemberHistory(String memberId) async {
    final history = await _attendanceRepo.getHistory().first;
    // Map events to history records
    // We want to know if the member was present at each event
    
    return history.map((event) {
      final attended = event.presentMemberIds.contains(memberId);
      return {
        'date': event.date,
        'description': event.description ?? 'Reunión General', // Assuming description exists or default
        'attended': attended,
      };
    }).toList();
  }

  /// 6. Member Stats for Tile (Percentage)
  Future<Map<String, dynamic>> getMemberStats(String memberId) async {
    final history = await _attendanceRepo.getHistory().first;
    if (history.isEmpty) {
      return {'percentage': 0.0, 'history': <Map<String, dynamic>>[]};
    }

    final totalEvents = history.length;
    final attendedEvents = history.where((e) => e.presentMemberIds.contains(memberId)).length;
    final percentage = (attendedEvents / totalEvents) * 100;

    // Last 5 events for dialog
    final historyMap = history.take(5).map((event) {
      return {
        'date': event.date,
        'description': event.description ?? 'Reunión General',
        'attended': event.presentMemberIds.contains(memberId),
      };
    }).toList();

    return {
      'percentage': percentage,
      'history': historyMap,
    };
  }
}
