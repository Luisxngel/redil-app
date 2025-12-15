import 'package:isar/isar.dart';
import '../../domain/entities/attendance.dart';

part 'attendance_model.g.dart';

@collection
class AttendanceModel {
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  late String id;

  late DateTime date;
  String? title; // NEW
  String? description;
  
  // CORRECCIÓN: Inicialización explícita y no-late para evitar nulos
  List<String> presentMemberIds = [];
  
  late String targetRole = 'ALL';
  
  // CRÍTICO: Inicialización explícita, se asegura persistencia
  List<String> invitedMemberIds = [];

  String? seriesId;

  static AttendanceModel fromEntity(Attendance attendance) {
    return AttendanceModel()
      ..id = attendance.id
      ..date = attendance.date
      ..title = attendance.title
      ..description = attendance.description
      // CRÍTICO: .from para romper referencia y asegurar tipo
      ..presentMemberIds = List<String>.from(attendance.presentMemberIds)
      ..targetRole = attendance.targetRole
      // CRÍTICO: Copia defensiva. Si llega null (no debería), usa []
      ..invitedMemberIds = List<String>.from(attendance.invitedMemberIds)
      ..seriesId = attendance.seriesId;
  }

  Attendance toEntity() {
    return Attendance(
      id: id,
      date: date,
      title: title,
      description: description,
      // CRÍTICO: Lectura segura
      presentMemberIds: List<String>.from(presentMemberIds),
      targetRole: targetRole,
      invitedMemberIds: List<String>.from(invitedMemberIds),
      seriesId: seriesId,
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
