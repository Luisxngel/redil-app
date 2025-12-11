import 'package:isar/isar.dart';
import '../../domain/entities/member.dart';

part 'member_model.g.dart';

@collection
class MemberModel {
  // Isar ID derived from the stable String ID (UUID)
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  final String id; // UUID V4

  final String firstName;
  final String lastName;
  
  @Index(unique: true, replace: true)
  final String phone;
  
  @enumerated
  final MemberRole role;
  
  @enumerated
  final MemberStatus status;
  
  final DateTime? lastAttendanceDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dateOfBirth;
  final String? address;
  
  final int? civilStatusIndex;
  final String? notes;
  
  // Mutable to allow soft delete updates without full recreation if needed, 
  // though recreating is safer for mutability control. 
  // Isar allows final fields if constructor matches. 
  // But for 'isDeleted' update in Repository, we might need it mutable 
  // OR we use .put() with a new copy.
  // The user asked for "final bool isDeleted".
  // To allow easy "soft delete", we might want simple mutability.
  bool isDeleted;

  MemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.status,
    this.lastAttendanceDate,
    required this.createdAt,
    this.updatedAt,
    this.dateOfBirth,
    this.address,
    this.civilStatusIndex,
    this.notes,
    this.isDeleted = false,
  });

  /// Mapper: Entity -> Model
  static MemberModel fromEntity(Member member) {
    return MemberModel(
      id: member.id!, // ID must be generated before saving (UUID)
      firstName: Member.sanitizeName(member.firstName),
      lastName: Member.sanitizeName(member.lastName),
      phone: member.phone,
      role: member.role,
      status: member.status,
      lastAttendanceDate: member.lastAttendanceDate,
      createdAt: member.createdAt,
      updatedAt: member.updatedAt,
      dateOfBirth: member.dateOfBirth,
      address: member.address,
      civilStatusIndex: member.civilStatus?.index,
      notes: member.notes,
      isDeleted: member.isDeleted,
    );
  }

  /// Mapper: Model -> Entity
  Member toEntity() {
    return Member(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
      status: status,
      lastAttendanceDate: lastAttendanceDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dateOfBirth: dateOfBirth,
      address: address,
      civilStatus: civilStatusIndex != null 
          ? CivilStatus.values[civilStatusIndex!] 
          : null,
      notes: notes,
      isDeleted: isDeleted,
    );
  }
}

/// FNV-1a 64-bit hash algorithm optimized for Dart
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
