import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_event.freezed.dart';

@freezed
class AttendanceEvent with _$AttendanceEvent {
  const factory AttendanceEvent.loadHistory() = LoadHistory;
  const factory AttendanceEvent.loadForm(String? attendanceId) = LoadForm;
  const factory AttendanceEvent.toggleMember(String memberId) = ToggleMember;
  const factory AttendanceEvent.saveEvent({
    required DateTime date,
    String? description,
  }) = SaveEvent;
  const factory AttendanceEvent.deleteEvent(String id) = DeleteEvent;
}
