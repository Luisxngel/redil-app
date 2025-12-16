import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../members/domain/entities/member.dart';

part 'member_form_state.freezed.dart';

@freezed
class MemberFormState with _$MemberFormState {
  const factory MemberFormState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? errorMessage,
    
    // Form Draft Fields
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String phone,
    @Default('') String address,
    DateTime? dateOfBirth,
    @Default(MemberRole.member) MemberRole role,
    @Default(MemberStatus.active) MemberStatus status,
    @Default(CivilStatus.single) CivilStatus civilStatus,
    @Default('') String notes,
    
    // New Fields
    String? photoPath,
    String? profession,
    
    // Original member (for edit mode)
    Member? originalMember,
  }) = _MemberFormState;
  
  const MemberFormState._();
  
  bool get isEditing => originalMember != null;
}
