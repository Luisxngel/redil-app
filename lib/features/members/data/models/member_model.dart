import 'package:isar/isar.dart';
import '../../domain/entities/member.dart';

part 'member_model.g.dart';

@collection
class MemberModel {
  Id id = Isar.autoIncrement;

  late String firstName;
  late String lastName;

  @Index(unique: true, replace: true)
  late String phone;

  @enumerated
  late MemberRole role;

  @enumerated
  late MemberStatus status;

  late DateTime? lastAttendanceDate;

  late DateTime createdAt;

  late DateTime? updatedAt;
  
  late DateTime? dateOfBirth;
  late String? address;
  
  late int? civilStatusIndex;
  
  late String? notes;
  
  late bool isDeleted = false;

  /// Mapper: Entity -> Model
  static MemberModel fromEntity(Member member) {
    final model = MemberModel()
      ..firstName = Member.sanitizeName(member.firstName)
      ..lastName = Member.sanitizeName(member.lastName)
      ..phone = member.phone
      ..role = member.role
      ..status = member.status
      ..lastAttendanceDate = member.lastAttendanceDate
      ..createdAt = member.createdAt
      ..updatedAt = member.updatedAt
      ..dateOfBirth = member.dateOfBirth
      ..address = member.address
      ..civilStatusIndex = member.civilStatus?.index
      ..notes = member.notes
      ..isDeleted = member.isDeleted;
    
    if (member.id != null) {
      model.id = int.tryParse(member.id!) ?? Isar.autoIncrement;
    }
    return model;
  }

  /// Mapper: Model -> Entity
  Member toEntity() {
    return Member(
      id: id.toString(),
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
