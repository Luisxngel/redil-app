import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../members/domain/entities/member.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded({
    required int activeCount,
    required double attendanceAverage,
    required List<Member> birthdayMembers,
    required List<Member> riskMembers,
  }) = DashboardLoaded;
  const factory DashboardState.error(String message) = _Error;
}
