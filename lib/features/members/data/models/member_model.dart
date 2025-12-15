import 'package:isar/isar.dart';
import '../../domain/entities/member.dart';

part 'member_model.g.dart';

@collection
class MemberModel {
  // Use Isar's auto-increment ID instead of hashing
  Id isarId = Isar.autoIncrement;

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
  
  bool isDeleted;
  bool isHarvested;
  DateTime? lastContacted; // NEW

  MemberModel({
    this.isarId = Isar.autoIncrement,
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
    this.isHarvested = false,
    this.lastContacted,
  });

  /// Mapper: Entity -> Model
  static MemberModel fromEntity(Member member) {
    return MemberModel(
      // isarId is not set here, it will be handled by logic or default
      id: member.id!, 
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
      isHarvested: member.isHarvested,
      lastContacted: member.lastContacted,
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
      isHarvested: isHarvested,
      lastContacted: lastContacted,
    );
  }
}
