import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/member.dart';

part 'members_state.freezed.dart';

@freezed
class MembersState with _$MembersState {
  const factory MembersState.initial() = Initial;
  const factory MembersState.loading() = Loading;
  const factory MembersState.loaded(List<Member> members) = Loaded;
  const factory MembersState.actionSuccess(String message) = ActionSuccess;
  const factory MembersState.error(String message) = Error;
}
