import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/statistics_service.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/entities/member_risk.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final StatisticsService _statsService;
  final AttendanceRepository _attendanceRepo;
  StreamSubscription? _attendanceSubscription;

  DashboardBloc(this._statsService, this._attendanceRepo) : super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);

    // Reactivity: Reload dashboard when attendance changes
    _attendanceSubscription = _attendanceRepo.getHistory().listen((_) {
      add(const LoadDashboardData());
    });
  }

  @override
  Future<void> close() {
    _attendanceSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadDashboardData(LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(const DashboardState.loading());
    try {
      // Parallel execution for efficiency
      final results = await Future.wait([
        _statsService.getActiveMembersCount(),
        _statsService.getAverageAttendance(),
        _statsService.getUpcomingBirthdays(),
        _statsService.getAttritionRiskMembers(),
        _statsService.getLastEventAttendanceCount(), // Index 4
        _statsService.getHarvestCount(), // Index 5
        _statsService.getLastEventAttendees(), // Index 6
        _statsService.getHarvestMembers(), // Index 7
      ]);

      emit(DashboardState.loaded(
        activeCount: results[0] as int,
        attendanceAverage: results[1] as double,
        birthdayMembers: results[2] as List<Member>,
        riskMembers: results[3] as List<MemberRisk>,
        lastEventAttendance: results[4] as int,
        harvestCount: results[5] as int,
        lastAttendees: results[6] as List<Member>,
        harvestMembers: results[7] as List<Member>,
      ));
    } catch (e) {
      emit(DashboardState.error("Error cargando dashboard: $e"));
    }
  }
}
