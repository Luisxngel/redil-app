// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AttendanceEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistory,
    required TResult Function(String? attendanceId) loadForm,
    required TResult Function(String memberId) toggleMember,
    required TResult Function(DateTime date, String? description,
            String targetRole, List<String> invitedMemberIds)
        saveEvent,
    required TResult Function(String id) deleteEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistory,
    TResult? Function(String? attendanceId)? loadForm,
    TResult? Function(String memberId)? toggleMember,
    TResult? Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult? Function(String id)? deleteEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistory,
    TResult Function(String? attendanceId)? loadForm,
    TResult Function(String memberId)? toggleMember,
    TResult Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult Function(String id)? deleteEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistory value) loadHistory,
    required TResult Function(LoadForm value) loadForm,
    required TResult Function(ToggleMember value) toggleMember,
    required TResult Function(SaveEvent value) saveEvent,
    required TResult Function(DeleteEvent value) deleteEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistory value)? loadHistory,
    TResult? Function(LoadForm value)? loadForm,
    TResult? Function(ToggleMember value)? toggleMember,
    TResult? Function(SaveEvent value)? saveEvent,
    TResult? Function(DeleteEvent value)? deleteEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistory value)? loadHistory,
    TResult Function(LoadForm value)? loadForm,
    TResult Function(ToggleMember value)? toggleMember,
    TResult Function(SaveEvent value)? saveEvent,
    TResult Function(DeleteEvent value)? deleteEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceEventCopyWith<$Res> {
  factory $AttendanceEventCopyWith(
          AttendanceEvent value, $Res Function(AttendanceEvent) then) =
      _$AttendanceEventCopyWithImpl<$Res, AttendanceEvent>;
}

/// @nodoc
class _$AttendanceEventCopyWithImpl<$Res, $Val extends AttendanceEvent>
    implements $AttendanceEventCopyWith<$Res> {
  _$AttendanceEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadHistoryImplCopyWith<$Res> {
  factory _$$LoadHistoryImplCopyWith(
          _$LoadHistoryImpl value, $Res Function(_$LoadHistoryImpl) then) =
      __$$LoadHistoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadHistoryImplCopyWithImpl<$Res>
    extends _$AttendanceEventCopyWithImpl<$Res, _$LoadHistoryImpl>
    implements _$$LoadHistoryImplCopyWith<$Res> {
  __$$LoadHistoryImplCopyWithImpl(
      _$LoadHistoryImpl _value, $Res Function(_$LoadHistoryImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadHistoryImpl implements LoadHistory {
  const _$LoadHistoryImpl();

  @override
  String toString() {
    return 'AttendanceEvent.loadHistory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadHistoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistory,
    required TResult Function(String? attendanceId) loadForm,
    required TResult Function(String memberId) toggleMember,
    required TResult Function(DateTime date, String? description,
            String targetRole, List<String> invitedMemberIds)
        saveEvent,
    required TResult Function(String id) deleteEvent,
  }) {
    return loadHistory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistory,
    TResult? Function(String? attendanceId)? loadForm,
    TResult? Function(String memberId)? toggleMember,
    TResult? Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult? Function(String id)? deleteEvent,
  }) {
    return loadHistory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistory,
    TResult Function(String? attendanceId)? loadForm,
    TResult Function(String memberId)? toggleMember,
    TResult Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult Function(String id)? deleteEvent,
    required TResult orElse(),
  }) {
    if (loadHistory != null) {
      return loadHistory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistory value) loadHistory,
    required TResult Function(LoadForm value) loadForm,
    required TResult Function(ToggleMember value) toggleMember,
    required TResult Function(SaveEvent value) saveEvent,
    required TResult Function(DeleteEvent value) deleteEvent,
  }) {
    return loadHistory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistory value)? loadHistory,
    TResult? Function(LoadForm value)? loadForm,
    TResult? Function(ToggleMember value)? toggleMember,
    TResult? Function(SaveEvent value)? saveEvent,
    TResult? Function(DeleteEvent value)? deleteEvent,
  }) {
    return loadHistory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistory value)? loadHistory,
    TResult Function(LoadForm value)? loadForm,
    TResult Function(ToggleMember value)? toggleMember,
    TResult Function(SaveEvent value)? saveEvent,
    TResult Function(DeleteEvent value)? deleteEvent,
    required TResult orElse(),
  }) {
    if (loadHistory != null) {
      return loadHistory(this);
    }
    return orElse();
  }
}

abstract class LoadHistory implements AttendanceEvent {
  const factory LoadHistory() = _$LoadHistoryImpl;
}

/// @nodoc
abstract class _$$LoadFormImplCopyWith<$Res> {
  factory _$$LoadFormImplCopyWith(
          _$LoadFormImpl value, $Res Function(_$LoadFormImpl) then) =
      __$$LoadFormImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? attendanceId});
}

/// @nodoc
class __$$LoadFormImplCopyWithImpl<$Res>
    extends _$AttendanceEventCopyWithImpl<$Res, _$LoadFormImpl>
    implements _$$LoadFormImplCopyWith<$Res> {
  __$$LoadFormImplCopyWithImpl(
      _$LoadFormImpl _value, $Res Function(_$LoadFormImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceId = freezed,
  }) {
    return _then(_$LoadFormImpl(
      freezed == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LoadFormImpl implements LoadForm {
  const _$LoadFormImpl(this.attendanceId);

  @override
  final String? attendanceId;

  @override
  String toString() {
    return 'AttendanceEvent.loadForm(attendanceId: $attendanceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadFormImpl &&
            (identical(other.attendanceId, attendanceId) ||
                other.attendanceId == attendanceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, attendanceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadFormImplCopyWith<_$LoadFormImpl> get copyWith =>
      __$$LoadFormImplCopyWithImpl<_$LoadFormImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistory,
    required TResult Function(String? attendanceId) loadForm,
    required TResult Function(String memberId) toggleMember,
    required TResult Function(DateTime date, String? description,
            String targetRole, List<String> invitedMemberIds)
        saveEvent,
    required TResult Function(String id) deleteEvent,
  }) {
    return loadForm(attendanceId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistory,
    TResult? Function(String? attendanceId)? loadForm,
    TResult? Function(String memberId)? toggleMember,
    TResult? Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult? Function(String id)? deleteEvent,
  }) {
    return loadForm?.call(attendanceId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistory,
    TResult Function(String? attendanceId)? loadForm,
    TResult Function(String memberId)? toggleMember,
    TResult Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult Function(String id)? deleteEvent,
    required TResult orElse(),
  }) {
    if (loadForm != null) {
      return loadForm(attendanceId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistory value) loadHistory,
    required TResult Function(LoadForm value) loadForm,
    required TResult Function(ToggleMember value) toggleMember,
    required TResult Function(SaveEvent value) saveEvent,
    required TResult Function(DeleteEvent value) deleteEvent,
  }) {
    return loadForm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistory value)? loadHistory,
    TResult? Function(LoadForm value)? loadForm,
    TResult? Function(ToggleMember value)? toggleMember,
    TResult? Function(SaveEvent value)? saveEvent,
    TResult? Function(DeleteEvent value)? deleteEvent,
  }) {
    return loadForm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistory value)? loadHistory,
    TResult Function(LoadForm value)? loadForm,
    TResult Function(ToggleMember value)? toggleMember,
    TResult Function(SaveEvent value)? saveEvent,
    TResult Function(DeleteEvent value)? deleteEvent,
    required TResult orElse(),
  }) {
    if (loadForm != null) {
      return loadForm(this);
    }
    return orElse();
  }
}

abstract class LoadForm implements AttendanceEvent {
  const factory LoadForm(final String? attendanceId) = _$LoadFormImpl;

  String? get attendanceId;
  @JsonKey(ignore: true)
  _$$LoadFormImplCopyWith<_$LoadFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToggleMemberImplCopyWith<$Res> {
  factory _$$ToggleMemberImplCopyWith(
          _$ToggleMemberImpl value, $Res Function(_$ToggleMemberImpl) then) =
      __$$ToggleMemberImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String memberId});
}

/// @nodoc
class __$$ToggleMemberImplCopyWithImpl<$Res>
    extends _$AttendanceEventCopyWithImpl<$Res, _$ToggleMemberImpl>
    implements _$$ToggleMemberImplCopyWith<$Res> {
  __$$ToggleMemberImplCopyWithImpl(
      _$ToggleMemberImpl _value, $Res Function(_$ToggleMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
  }) {
    return _then(_$ToggleMemberImpl(
      null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ToggleMemberImpl implements ToggleMember {
  const _$ToggleMemberImpl(this.memberId);

  @override
  final String memberId;

  @override
  String toString() {
    return 'AttendanceEvent.toggleMember(memberId: $memberId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleMemberImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleMemberImplCopyWith<_$ToggleMemberImpl> get copyWith =>
      __$$ToggleMemberImplCopyWithImpl<_$ToggleMemberImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistory,
    required TResult Function(String? attendanceId) loadForm,
    required TResult Function(String memberId) toggleMember,
    required TResult Function(DateTime date, String? description,
            String targetRole, List<String> invitedMemberIds)
        saveEvent,
    required TResult Function(String id) deleteEvent,
  }) {
    return toggleMember(memberId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistory,
    TResult? Function(String? attendanceId)? loadForm,
    TResult? Function(String memberId)? toggleMember,
    TResult? Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult? Function(String id)? deleteEvent,
  }) {
    return toggleMember?.call(memberId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistory,
    TResult Function(String? attendanceId)? loadForm,
    TResult Function(String memberId)? toggleMember,
    TResult Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult Function(String id)? deleteEvent,
    required TResult orElse(),
  }) {
    if (toggleMember != null) {
      return toggleMember(memberId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistory value) loadHistory,
    required TResult Function(LoadForm value) loadForm,
    required TResult Function(ToggleMember value) toggleMember,
    required TResult Function(SaveEvent value) saveEvent,
    required TResult Function(DeleteEvent value) deleteEvent,
  }) {
    return toggleMember(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistory value)? loadHistory,
    TResult? Function(LoadForm value)? loadForm,
    TResult? Function(ToggleMember value)? toggleMember,
    TResult? Function(SaveEvent value)? saveEvent,
    TResult? Function(DeleteEvent value)? deleteEvent,
  }) {
    return toggleMember?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistory value)? loadHistory,
    TResult Function(LoadForm value)? loadForm,
    TResult Function(ToggleMember value)? toggleMember,
    TResult Function(SaveEvent value)? saveEvent,
    TResult Function(DeleteEvent value)? deleteEvent,
    required TResult orElse(),
  }) {
    if (toggleMember != null) {
      return toggleMember(this);
    }
    return orElse();
  }
}

abstract class ToggleMember implements AttendanceEvent {
  const factory ToggleMember(final String memberId) = _$ToggleMemberImpl;

  String get memberId;
  @JsonKey(ignore: true)
  _$$ToggleMemberImplCopyWith<_$ToggleMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveEventImplCopyWith<$Res> {
  factory _$$SaveEventImplCopyWith(
          _$SaveEventImpl value, $Res Function(_$SaveEventImpl) then) =
      __$$SaveEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {DateTime date,
      String? description,
      String targetRole,
      List<String> invitedMemberIds});
}

/// @nodoc
class __$$SaveEventImplCopyWithImpl<$Res>
    extends _$AttendanceEventCopyWithImpl<$Res, _$SaveEventImpl>
    implements _$$SaveEventImplCopyWith<$Res> {
  __$$SaveEventImplCopyWithImpl(
      _$SaveEventImpl _value, $Res Function(_$SaveEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? description = freezed,
    Object? targetRole = null,
    Object? invitedMemberIds = null,
  }) {
    return _then(_$SaveEventImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetRole: null == targetRole
          ? _value.targetRole
          : targetRole // ignore: cast_nullable_to_non_nullable
              as String,
      invitedMemberIds: null == invitedMemberIds
          ? _value._invitedMemberIds
          : invitedMemberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$SaveEventImpl implements SaveEvent {
  const _$SaveEventImpl(
      {required this.date,
      this.description,
      this.targetRole = 'ALL',
      final List<String> invitedMemberIds = const []})
      : _invitedMemberIds = invitedMemberIds;

  @override
  final DateTime date;
  @override
  final String? description;
  @override
  @JsonKey()
  final String targetRole;
  final List<String> _invitedMemberIds;
  @override
  @JsonKey()
  List<String> get invitedMemberIds {
    if (_invitedMemberIds is EqualUnmodifiableListView)
      return _invitedMemberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invitedMemberIds);
  }

  @override
  String toString() {
    return 'AttendanceEvent.saveEvent(date: $date, description: $description, targetRole: $targetRole, invitedMemberIds: $invitedMemberIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveEventImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetRole, targetRole) ||
                other.targetRole == targetRole) &&
            const DeepCollectionEquality()
                .equals(other._invitedMemberIds, _invitedMemberIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, description, targetRole,
      const DeepCollectionEquality().hash(_invitedMemberIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveEventImplCopyWith<_$SaveEventImpl> get copyWith =>
      __$$SaveEventImplCopyWithImpl<_$SaveEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistory,
    required TResult Function(String? attendanceId) loadForm,
    required TResult Function(String memberId) toggleMember,
    required TResult Function(DateTime date, String? description,
            String targetRole, List<String> invitedMemberIds)
        saveEvent,
    required TResult Function(String id) deleteEvent,
  }) {
    return saveEvent(date, description, targetRole, invitedMemberIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistory,
    TResult? Function(String? attendanceId)? loadForm,
    TResult? Function(String memberId)? toggleMember,
    TResult? Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult? Function(String id)? deleteEvent,
  }) {
    return saveEvent?.call(date, description, targetRole, invitedMemberIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistory,
    TResult Function(String? attendanceId)? loadForm,
    TResult Function(String memberId)? toggleMember,
    TResult Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult Function(String id)? deleteEvent,
    required TResult orElse(),
  }) {
    if (saveEvent != null) {
      return saveEvent(date, description, targetRole, invitedMemberIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistory value) loadHistory,
    required TResult Function(LoadForm value) loadForm,
    required TResult Function(ToggleMember value) toggleMember,
    required TResult Function(SaveEvent value) saveEvent,
    required TResult Function(DeleteEvent value) deleteEvent,
  }) {
    return saveEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistory value)? loadHistory,
    TResult? Function(LoadForm value)? loadForm,
    TResult? Function(ToggleMember value)? toggleMember,
    TResult? Function(SaveEvent value)? saveEvent,
    TResult? Function(DeleteEvent value)? deleteEvent,
  }) {
    return saveEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistory value)? loadHistory,
    TResult Function(LoadForm value)? loadForm,
    TResult Function(ToggleMember value)? toggleMember,
    TResult Function(SaveEvent value)? saveEvent,
    TResult Function(DeleteEvent value)? deleteEvent,
    required TResult orElse(),
  }) {
    if (saveEvent != null) {
      return saveEvent(this);
    }
    return orElse();
  }
}

abstract class SaveEvent implements AttendanceEvent {
  const factory SaveEvent(
      {required final DateTime date,
      final String? description,
      final String targetRole,
      final List<String> invitedMemberIds}) = _$SaveEventImpl;

  DateTime get date;
  String? get description;
  String get targetRole;
  List<String> get invitedMemberIds;
  @JsonKey(ignore: true)
  _$$SaveEventImplCopyWith<_$SaveEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteEventImplCopyWith<$Res> {
  factory _$$DeleteEventImplCopyWith(
          _$DeleteEventImpl value, $Res Function(_$DeleteEventImpl) then) =
      __$$DeleteEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$DeleteEventImplCopyWithImpl<$Res>
    extends _$AttendanceEventCopyWithImpl<$Res, _$DeleteEventImpl>
    implements _$$DeleteEventImplCopyWith<$Res> {
  __$$DeleteEventImplCopyWithImpl(
      _$DeleteEventImpl _value, $Res Function(_$DeleteEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$DeleteEventImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteEventImpl implements DeleteEvent {
  const _$DeleteEventImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'AttendanceEvent.deleteEvent(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteEventImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteEventImplCopyWith<_$DeleteEventImpl> get copyWith =>
      __$$DeleteEventImplCopyWithImpl<_$DeleteEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistory,
    required TResult Function(String? attendanceId) loadForm,
    required TResult Function(String memberId) toggleMember,
    required TResult Function(DateTime date, String? description,
            String targetRole, List<String> invitedMemberIds)
        saveEvent,
    required TResult Function(String id) deleteEvent,
  }) {
    return deleteEvent(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistory,
    TResult? Function(String? attendanceId)? loadForm,
    TResult? Function(String memberId)? toggleMember,
    TResult? Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult? Function(String id)? deleteEvent,
  }) {
    return deleteEvent?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistory,
    TResult Function(String? attendanceId)? loadForm,
    TResult Function(String memberId)? toggleMember,
    TResult Function(DateTime date, String? description, String targetRole,
            List<String> invitedMemberIds)?
        saveEvent,
    TResult Function(String id)? deleteEvent,
    required TResult orElse(),
  }) {
    if (deleteEvent != null) {
      return deleteEvent(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistory value) loadHistory,
    required TResult Function(LoadForm value) loadForm,
    required TResult Function(ToggleMember value) toggleMember,
    required TResult Function(SaveEvent value) saveEvent,
    required TResult Function(DeleteEvent value) deleteEvent,
  }) {
    return deleteEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistory value)? loadHistory,
    TResult? Function(LoadForm value)? loadForm,
    TResult? Function(ToggleMember value)? toggleMember,
    TResult? Function(SaveEvent value)? saveEvent,
    TResult? Function(DeleteEvent value)? deleteEvent,
  }) {
    return deleteEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistory value)? loadHistory,
    TResult Function(LoadForm value)? loadForm,
    TResult Function(ToggleMember value)? toggleMember,
    TResult Function(SaveEvent value)? saveEvent,
    TResult Function(DeleteEvent value)? deleteEvent,
    required TResult orElse(),
  }) {
    if (deleteEvent != null) {
      return deleteEvent(this);
    }
    return orElse();
  }
}

abstract class DeleteEvent implements AttendanceEvent {
  const factory DeleteEvent(final String id) = _$DeleteEventImpl;

  String get id;
  @JsonKey(ignore: true)
  _$$DeleteEventImplCopyWith<_$DeleteEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
