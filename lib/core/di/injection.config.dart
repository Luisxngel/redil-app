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

import '../../features/members/data/repositories/member_repository_impl.dart'
    as _i6;
import '../../features/members/domain/repositories/member_repository.dart'
    as _i5;
import '../../features/members/presentation/bloc/members_bloc.dart' as _i7;
import '../services/communication_service.dart' as _i3;
import 'injection.dart' as _i8;

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
    return this;
  }
}

class _$IsarModule extends _i8.IsarModule {}
