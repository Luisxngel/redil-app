import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/statistics_service.dart';
import '../../../members/domain/entities/member.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final StatisticsService _statsService;

  DashboardBloc(this._statsService) : super(const DashboardState.initial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
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
      ]);

      emit(DashboardState.loaded(
        activeCount: results[0] as int,
        attendanceAverage: results[1] as double,
        birthdayMembers: results[2] as List<Member>,
        riskMembers: results[3] as List<Member>,
      ));
    } catch (e) {
      emit(DashboardState.error("Error cargando dashboard: $e"));
    }
  }
}
