import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/entities/member_risk.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded({
    required int activeCount,
    required double attendanceAverage,
    required int lastEventAttendance, // Derived or kept for ease
    required List<Member> lastAttendees, // NEW
    required int harvestCount, // Derived or kept
    required List<Member> harvestMembers, // NEW
    required List<Member> birthdayMembers,
    required List<MemberRisk> riskMembers,
  }) = DashboardLoaded;
  const factory DashboardState.error(String message) = _Error;
}
