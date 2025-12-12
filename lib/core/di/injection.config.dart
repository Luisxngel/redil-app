// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i4;

import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i10;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i9;
import '../../features/attendance/presentation/bloc/attendance_bloc.dart'
    as _i12;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart' as _i13;
import '../../features/members/data/repositories/member_repository_impl.dart'
    as _i6;
import '../../features/members/domain/repositories/member_repository.dart'
    as _i5;
import '../../features/members/presentation/bloc/members_bloc.dart' as _i7;
import '../services/communication_service.dart' as _i3;
import '../services/statistics_service.dart' as _i11;
import '../theme/theme_cubit.dart' as _i8;
import 'injection.dart' as _i14;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final isarModule = _$IsarModule();
    gh.lazySingleton<_i3.CommunicationService>(
        () => _i3.CommunicationService());
    await gh.factoryAsync<_i4.Isar>(
      () => isarModule.isar,
      preResolve: true,
    );
    gh.lazySingleton<_i5.MemberRepository>(
        () => _i6.MemberRepositoryImpl(gh<_i4.Isar>()));
    gh.factory<_i7.MembersBloc>(
        () => _i7.MembersBloc(gh<_i5.MemberRepository>()));
    gh.singleton<_i8.ThemeCubit>(() => _i8.ThemeCubit());
    gh.lazySingleton<_i9.AttendanceRepository>(
        () => _i10.AttendanceRepositoryImpl(gh<_i4.Isar>()));
    gh.lazySingleton<_i11.StatisticsService>(() => _i11.StatisticsService(
          gh<_i5.MemberRepository>(),
          gh<_i9.AttendanceRepository>(),
        ));
    gh.factory<_i12.AttendanceBloc>(() => _i12.AttendanceBloc(
          gh<_i9.AttendanceRepository>(),
          gh<_i5.MemberRepository>(),
        ));
    gh.factory<_i13.DashboardBloc>(
        () => _i13.DashboardBloc(gh<_i11.StatisticsService>()));
    return this;
  }
}

class _$IsarModule extends _i14.IsarModule {}
