// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i9;

import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i12;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i11;
import '../../features/attendance/presentation/bloc/attendance_bloc.dart'
    as _i18;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart' as _i19;
import '../../features/members/data/repositories/member_repository_impl.dart'
    as _i7;
import '../../features/members/domain/repositories/member_repository.dart'
    as _i6;
import '../../features/members/presentation/bloc/member_form/member_form_bloc.dart'
    as _i14;
import '../../features/members/presentation/bloc/members_bloc.dart' as _i15;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i16;
import '../../features/settings/services/backup_service.dart' as _i13;
import '../providers/date_time_provider.dart' as _i4;
import '../services/communication_service.dart' as _i3;
import '../services/pdf_service.dart' as _i8;
import '../services/statistics_service.dart' as _i17;
import '../theme/theme_cubit.dart' as _i10;
import 'injection.dart' as _i20;

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
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.CommunicationService>(
        () => _i3.CommunicationService());
    gh.singleton<_i4.IDateTimeProvider>(() => _i4.SystemDateTimeProvider());
    await gh.factoryAsync<_i5.Isar>(
      () => isarModule.isar,
      preResolve: true,
    );
    gh.lazySingleton<_i6.MemberRepository>(
        () => _i7.MemberRepositoryImpl(gh<_i5.Isar>()));
    gh.lazySingleton<_i8.PdfService>(() => _i8.PdfService());
    await gh.factoryAsync<_i9.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i10.ThemeCubit>(() => _i10.ThemeCubit());
    gh.lazySingleton<_i11.AttendanceRepository>(
        () => _i12.AttendanceRepositoryImpl(gh<_i5.Isar>()));
    gh.lazySingleton<_i13.BackupService>(() => _i13.BackupService(
          gh<_i6.MemberRepository>(),
          gh<_i11.AttendanceRepository>(),
        ));
    gh.factory<_i14.MemberFormBloc>(
        () => _i14.MemberFormBloc(gh<_i6.MemberRepository>()));
    gh.factory<_i15.MembersBloc>(() => _i15.MembersBloc(
          gh<_i6.MemberRepository>(),
          gh<_i11.AttendanceRepository>(),
        ));
    gh.factory<_i16.SettingsBloc>(
        () => _i16.SettingsBloc(gh<_i9.SharedPreferences>()));
    gh.lazySingleton<_i17.StatisticsService>(() => _i17.StatisticsService(
          gh<_i6.MemberRepository>(),
          gh<_i11.AttendanceRepository>(),
          gh<_i4.IDateTimeProvider>(),
        ));
    gh.factory<_i18.AttendanceBloc>(() => _i18.AttendanceBloc(
          gh<_i11.AttendanceRepository>(),
          gh<_i6.MemberRepository>(),
          gh<_i4.IDateTimeProvider>(),
        ));
    gh.factory<_i19.DashboardBloc>(() => _i19.DashboardBloc(
          gh<_i17.StatisticsService>(),
          gh<_i11.AttendanceRepository>(),
        ));
    return this;
  }
}

class _$IsarModule extends _i20.IsarModule {}

class _$RegisterModule extends _i20.RegisterModule {}
