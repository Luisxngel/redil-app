import 'package:isar/isar.dart';
import '../../domain/entities/attendance.dart';

part 'attendance_model.g.dart';

@collection
class AttendanceModel {
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  late String id;

  late DateTime date;
  late String? description;
  
  late List<String> presentMemberIds;

  static AttendanceModel fromEntity(Attendance attendance) {
    return AttendanceModel()
      ..id = attendance.id
      ..date = attendance.date
      ..description = attendance.description
      ..presentMemberIds = attendance.presentMemberIds;
  }

  Attendance toEntity() {
    return Attendance(
      id: id,
      date: date,
      description: description,
      presentMemberIds: presentMemberIds,
    );
  }
}

/// FNV-1a 64-bit hash algorithm optimized for Dart
/// Duplicated here to avoid cross-feature dependency on MemberModel's file
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
