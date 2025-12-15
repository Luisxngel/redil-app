import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/attendance.dart';

part 'attendance_group.freezed.dart';

@freezed
class AttendanceGroup with _$AttendanceGroup {
  const factory AttendanceGroup({
    required Attendance mainEvent,
    required int count,
    required bool isRecurring,
  }) = _AttendanceGroup;
}
