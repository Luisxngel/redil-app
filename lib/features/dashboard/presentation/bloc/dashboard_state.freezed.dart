// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res, DashboardState>;
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'DashboardState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements DashboardState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'DashboardState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements DashboardState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$DashboardLoadedImplCopyWith<$Res> {
  factory _$$DashboardLoadedImplCopyWith(_$DashboardLoadedImpl value,
          $Res Function(_$DashboardLoadedImpl) then) =
      __$$DashboardLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int activeCount,
      double attendanceAverage,
      List<Member> birthdayMembers,
      List<MemberRisk> riskMembers});
}

/// @nodoc
class __$$DashboardLoadedImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardLoadedImpl>
    implements _$$DashboardLoadedImplCopyWith<$Res> {
  __$$DashboardLoadedImplCopyWithImpl(
      _$DashboardLoadedImpl _value, $Res Function(_$DashboardLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeCount = null,
    Object? attendanceAverage = null,
    Object? birthdayMembers = null,
    Object? riskMembers = null,
  }) {
    return _then(_$DashboardLoadedImpl(
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      attendanceAverage: null == attendanceAverage
          ? _value.attendanceAverage
          : attendanceAverage // ignore: cast_nullable_to_non_nullable
              as double,
      birthdayMembers: null == birthdayMembers
          ? _value._birthdayMembers
          : birthdayMembers // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      riskMembers: null == riskMembers
          ? _value._riskMembers
          : riskMembers // ignore: cast_nullable_to_non_nullable
              as List<MemberRisk>,
    ));
  }
}

/// @nodoc

class _$DashboardLoadedImpl implements DashboardLoaded {
  const _$DashboardLoadedImpl(
      {required this.activeCount,
      required this.attendanceAverage,
      required final List<Member> birthdayMembers,
      required final List<MemberRisk> riskMembers})
      : _birthdayMembers = birthdayMembers,
        _riskMembers = riskMembers;

  @override
  final int activeCount;
  @override
  final double attendanceAverage;
  final List<Member> _birthdayMembers;
  @override
  List<Member> get birthdayMembers {
    if (_birthdayMembers is EqualUnmodifiableListView) return _birthdayMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_birthdayMembers);
  }

  final List<MemberRisk> _riskMembers;
  @override
  List<MemberRisk> get riskMembers {
    if (_riskMembers is EqualUnmodifiableListView) return _riskMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_riskMembers);
  }

  @override
  String toString() {
    return 'DashboardState.loaded(activeCount: $activeCount, attendanceAverage: $attendanceAverage, birthdayMembers: $birthdayMembers, riskMembers: $riskMembers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardLoadedImpl &&
            (identical(other.activeCount, activeCount) ||
                other.activeCount == activeCount) &&
            (identical(other.attendanceAverage, attendanceAverage) ||
                other.attendanceAverage == attendanceAverage) &&
            const DeepCollectionEquality()
                .equals(other._birthdayMembers, _birthdayMembers) &&
            const DeepCollectionEquality()
                .equals(other._riskMembers, _riskMembers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeCount,
      attendanceAverage,
      const DeepCollectionEquality().hash(_birthdayMembers),
      const DeepCollectionEquality().hash(_riskMembers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardLoadedImplCopyWith<_$DashboardLoadedImpl> get copyWith =>
      __$$DashboardLoadedImplCopyWithImpl<_$DashboardLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(activeCount, attendanceAverage, birthdayMembers, riskMembers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
        activeCount, attendanceAverage, birthdayMembers, riskMembers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
          activeCount, attendanceAverage, birthdayMembers, riskMembers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class DashboardLoaded implements DashboardState {
  const factory DashboardLoaded(
      {required final int activeCount,
      required final double attendanceAverage,
      required final List<Member> birthdayMembers,
      required final List<MemberRisk> riskMembers}) = _$DashboardLoadedImpl;

  int get activeCount;
  double get attendanceAverage;
  List<Member> get birthdayMembers;
  List<MemberRisk> get riskMembers;
  @JsonKey(ignore: true)
  _$$DashboardLoadedImplCopyWith<_$DashboardLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'DashboardState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(int activeCount, double attendanceAverage,
            List<Member> birthdayMembers, List<MemberRisk> riskMembers)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(DashboardLoaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(DashboardLoaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(DashboardLoaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements DashboardState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
