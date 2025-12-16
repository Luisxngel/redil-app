import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../members/domain/entities/member.dart';

part 'member_form_event.freezed.dart';

@freezed
class MemberFormEvent with _$MemberFormEvent {
  const factory MemberFormEvent.initialize(Member? member) = Initialize;
  const factory MemberFormEvent.firstNameChanged(String value) = FirstNameChanged;
  const factory MemberFormEvent.lastNameChanged(String value) = LastNameChanged;
  const factory MemberFormEvent.phoneChanged(String value) = PhoneChanged;
  const factory MemberFormEvent.addressChanged(String value) = AddressChanged;
  const factory MemberFormEvent.roleChanged(MemberRole value) = RoleChanged;
  const factory MemberFormEvent.statusChanged(MemberStatus value) = StatusChanged;
  const factory MemberFormEvent.civilStatusChanged(CivilStatus value) = CivilStatusChanged;
  const factory MemberFormEvent.dateOfBirthChanged(DateTime? value) = DateOfBirthChanged;
  const factory MemberFormEvent.notesChanged(String value) = NotesChanged;
  
  // New Events
  const factory MemberFormEvent.photoChanged(String path) = PhotoChanged;
  const factory MemberFormEvent.professionChanged(String value) = ProfessionChanged;
  
  const factory MemberFormEvent.submit() = Submit;
}
