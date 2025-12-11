import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/member.dart';

part 'members_event.freezed.dart';

@freezed
class MembersEvent with _$MembersEvent {
  const factory MembersEvent.loadMembers() = LoadMembers;
  const factory MembersEvent.addMember(Member member) = AddMember;
  const factory MembersEvent.deleteMember(String id) = DeleteMember;
  const factory MembersEvent.searchMembers(String query) = SearchMembers;
  const factory MembersEvent.loadTrash() = LoadTrash;
  const factory MembersEvent.restoreMember(String id) = RestoreMember;
  const factory MembersEvent.hardDeleteMember(String id) = HardDeleteMember;
  const factory MembersEvent.wipeAllData() = WipeAllData;
  const factory MembersEvent.filterByStatus(MemberStatus? status) = FilterByStatus;
}
