import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../members/domain/entities/member.dart';
import '../../domain/entities/attendance.dart';

part 'attendance_state.freezed.dart';

@freezed
class AttendanceState with _$AttendanceState {
  const factory AttendanceState.initial() = _Initial;
  const factory AttendanceState.loading() = _Loading;
  
  const factory AttendanceState.historyLoaded(List<Attendance> history) = HistoryLoaded;
  
  const factory AttendanceState.formLoaded({
    Attendance? existingEvent, // Null if new
    required List<Member> allMembers,
    required Set<String> selectedMemberIds,
  }) = FormLoaded;

  const factory AttendanceState.actionSuccess(String message) = ActionSuccess;
  const factory AttendanceState.error(String message) = Error;
}
