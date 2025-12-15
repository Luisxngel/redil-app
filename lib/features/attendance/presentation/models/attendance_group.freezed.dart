// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AttendanceGroup {
  Attendance get mainEvent => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AttendanceGroupCopyWith<AttendanceGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceGroupCopyWith<$Res> {
  factory $AttendanceGroupCopyWith(
          AttendanceGroup value, $Res Function(AttendanceGroup) then) =
      _$AttendanceGroupCopyWithImpl<$Res, AttendanceGroup>;
  @useResult
  $Res call({Attendance mainEvent, int count, bool isRecurring});
}

/// @nodoc
class _$AttendanceGroupCopyWithImpl<$Res, $Val extends AttendanceGroup>
    implements $AttendanceGroupCopyWith<$Res> {
  _$AttendanceGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainEvent = null,
    Object? count = null,
    Object? isRecurring = null,
  }) {
    return _then(_value.copyWith(
      mainEvent: null == mainEvent
          ? _value.mainEvent
          : mainEvent // ignore: cast_nullable_to_non_nullable
              as Attendance,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceGroupImplCopyWith<$Res>
    implements $AttendanceGroupCopyWith<$Res> {
  factory _$$AttendanceGroupImplCopyWith(_$AttendanceGroupImpl value,
          $Res Function(_$AttendanceGroupImpl) then) =
      __$$AttendanceGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Attendance mainEvent, int count, bool isRecurring});
}

/// @nodoc
class __$$AttendanceGroupImplCopyWithImpl<$Res>
    extends _$AttendanceGroupCopyWithImpl<$Res, _$AttendanceGroupImpl>
    implements _$$AttendanceGroupImplCopyWith<$Res> {
  __$$AttendanceGroupImplCopyWithImpl(
      _$AttendanceGroupImpl _value, $Res Function(_$AttendanceGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainEvent = null,
    Object? count = null,
    Object? isRecurring = null,
  }) {
    return _then(_$AttendanceGroupImpl(
      mainEvent: null == mainEvent
          ? _value.mainEvent
          : mainEvent // ignore: cast_nullable_to_non_nullable
              as Attendance,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AttendanceGroupImpl implements _AttendanceGroup {
  const _$AttendanceGroupImpl(
      {required this.mainEvent,
      required this.count,
      required this.isRecurring});

  @override
  final Attendance mainEvent;
  @override
  final int count;
  @override
  final bool isRecurring;

  @override
  String toString() {
    return 'AttendanceGroup(mainEvent: $mainEvent, count: $count, isRecurring: $isRecurring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceGroupImpl &&
            (identical(other.mainEvent, mainEvent) ||
                other.mainEvent == mainEvent) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mainEvent, count, isRecurring);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceGroupImplCopyWith<_$AttendanceGroupImpl> get copyWith =>
      __$$AttendanceGroupImplCopyWithImpl<_$AttendanceGroupImpl>(
          this, _$identity);
}

abstract class _AttendanceGroup implements AttendanceGroup {
  const factory _AttendanceGroup(
      {required final Attendance mainEvent,
      required final int count,
      required final bool isRecurring}) = _$AttendanceGroupImpl;

  @override
  Attendance get mainEvent;
  @override
  int get count;
  @override
  bool get isRecurring;
  @override
  @JsonKey(ignore: true)
  _$$AttendanceGroupImplCopyWith<_$AttendanceGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
