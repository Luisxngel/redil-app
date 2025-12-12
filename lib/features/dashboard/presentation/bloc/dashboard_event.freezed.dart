// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadDashboardData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadDashboardData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadDashboardData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDashboardData value) loadDashboardData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDashboardData value)? loadDashboardData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDashboardData value)? loadDashboardData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardEventCopyWith<$Res> {
  factory $DashboardEventCopyWith(
          DashboardEvent value, $Res Function(DashboardEvent) then) =
      _$DashboardEventCopyWithImpl<$Res, DashboardEvent>;
}

/// @nodoc
class _$DashboardEventCopyWithImpl<$Res, $Val extends DashboardEvent>
    implements $DashboardEventCopyWith<$Res> {
  _$DashboardEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadDashboardDataImplCopyWith<$Res> {
  factory _$$LoadDashboardDataImplCopyWith(_$LoadDashboardDataImpl value,
          $Res Function(_$LoadDashboardDataImpl) then) =
      __$$LoadDashboardDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadDashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res, _$LoadDashboardDataImpl>
    implements _$$LoadDashboardDataImplCopyWith<$Res> {
  __$$LoadDashboardDataImplCopyWithImpl(_$LoadDashboardDataImpl _value,
      $Res Function(_$LoadDashboardDataImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadDashboardDataImpl implements LoadDashboardData {
  const _$LoadDashboardDataImpl();

  @override
  String toString() {
    return 'DashboardEvent.loadDashboardData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadDashboardDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadDashboardData,
  }) {
    return loadDashboardData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadDashboardData,
  }) {
    return loadDashboardData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadDashboardData,
    required TResult orElse(),
  }) {
    if (loadDashboardData != null) {
      return loadDashboardData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDashboardData value) loadDashboardData,
  }) {
    return loadDashboardData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDashboardData value)? loadDashboardData,
  }) {
    return loadDashboardData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDashboardData value)? loadDashboardData,
    required TResult orElse(),
  }) {
    if (loadDashboardData != null) {
      return loadDashboardData(this);
    }
    return orElse();
  }
}

abstract class LoadDashboardData implements DashboardEvent {
  const factory LoadDashboardData() = _$LoadDashboardDataImpl;
}
