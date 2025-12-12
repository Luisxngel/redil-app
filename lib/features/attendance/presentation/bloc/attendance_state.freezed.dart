// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AttendanceState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceStateCopyWith<$Res> {
  factory $AttendanceStateCopyWith(
          AttendanceState value, $Res Function(AttendanceState) then) =
      _$AttendanceStateCopyWithImpl<$Res, AttendanceState>;
}

/// @nodoc
class _$AttendanceStateCopyWithImpl<$Res, $Val extends AttendanceState>
    implements $AttendanceStateCopyWith<$Res> {
  _$AttendanceStateCopyWithImpl(this._value, this._then);

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
    extends _$AttendanceStateCopyWithImpl<$Res, _$InitialImpl>
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
    return 'AttendanceState.initial()';
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
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
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
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AttendanceState {
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
    extends _$AttendanceStateCopyWithImpl<$Res, _$LoadingImpl>
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
    return 'AttendanceState.loading()';
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
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
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
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements AttendanceState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$HistoryLoadedImplCopyWith<$Res> {
  factory _$$HistoryLoadedImplCopyWith(
          _$HistoryLoadedImpl value, $Res Function(_$HistoryLoadedImpl) then) =
      __$$HistoryLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Attendance> history});
}

/// @nodoc
class __$$HistoryLoadedImplCopyWithImpl<$Res>
    extends _$AttendanceStateCopyWithImpl<$Res, _$HistoryLoadedImpl>
    implements _$$HistoryLoadedImplCopyWith<$Res> {
  __$$HistoryLoadedImplCopyWithImpl(
      _$HistoryLoadedImpl _value, $Res Function(_$HistoryLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? history = null,
  }) {
    return _then(_$HistoryLoadedImpl(
      null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<Attendance>,
    ));
  }
}

/// @nodoc

class _$HistoryLoadedImpl implements HistoryLoaded {
  const _$HistoryLoadedImpl(final List<Attendance> history)
      : _history = history;

  final List<Attendance> _history;
  @override
  List<Attendance> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'AttendanceState.historyLoaded(history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryLoadedImpl &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_history));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryLoadedImplCopyWith<_$HistoryLoadedImpl> get copyWith =>
      __$$HistoryLoadedImplCopyWithImpl<_$HistoryLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) {
    return historyLoaded(history);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) {
    return historyLoaded?.call(history);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (historyLoaded != null) {
      return historyLoaded(history);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) {
    return historyLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) {
    return historyLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (historyLoaded != null) {
      return historyLoaded(this);
    }
    return orElse();
  }
}

abstract class HistoryLoaded implements AttendanceState {
  const factory HistoryLoaded(final List<Attendance> history) =
      _$HistoryLoadedImpl;

  List<Attendance> get history;
  @JsonKey(ignore: true)
  _$$HistoryLoadedImplCopyWith<_$HistoryLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FormLoadedImplCopyWith<$Res> {
  factory _$$FormLoadedImplCopyWith(
          _$FormLoadedImpl value, $Res Function(_$FormLoadedImpl) then) =
      __$$FormLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Attendance? existingEvent,
      List<Member> allMembers,
      Set<String> selectedMemberIds});
}

/// @nodoc
class __$$FormLoadedImplCopyWithImpl<$Res>
    extends _$AttendanceStateCopyWithImpl<$Res, _$FormLoadedImpl>
    implements _$$FormLoadedImplCopyWith<$Res> {
  __$$FormLoadedImplCopyWithImpl(
      _$FormLoadedImpl _value, $Res Function(_$FormLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? existingEvent = freezed,
    Object? allMembers = null,
    Object? selectedMemberIds = null,
  }) {
    return _then(_$FormLoadedImpl(
      existingEvent: freezed == existingEvent
          ? _value.existingEvent
          : existingEvent // ignore: cast_nullable_to_non_nullable
              as Attendance?,
      allMembers: null == allMembers
          ? _value._allMembers
          : allMembers // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      selectedMemberIds: null == selectedMemberIds
          ? _value._selectedMemberIds
          : selectedMemberIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$FormLoadedImpl implements FormLoaded {
  const _$FormLoadedImpl(
      {this.existingEvent,
      required final List<Member> allMembers,
      required final Set<String> selectedMemberIds})
      : _allMembers = allMembers,
        _selectedMemberIds = selectedMemberIds;

  @override
  final Attendance? existingEvent;
// Null if new
  final List<Member> _allMembers;
// Null if new
  @override
  List<Member> get allMembers {
    if (_allMembers is EqualUnmodifiableListView) return _allMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allMembers);
  }

  final Set<String> _selectedMemberIds;
  @override
  Set<String> get selectedMemberIds {
    if (_selectedMemberIds is EqualUnmodifiableSetView)
      return _selectedMemberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedMemberIds);
  }

  @override
  String toString() {
    return 'AttendanceState.formLoaded(existingEvent: $existingEvent, allMembers: $allMembers, selectedMemberIds: $selectedMemberIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormLoadedImpl &&
            (identical(other.existingEvent, existingEvent) ||
                other.existingEvent == existingEvent) &&
            const DeepCollectionEquality()
                .equals(other._allMembers, _allMembers) &&
            const DeepCollectionEquality()
                .equals(other._selectedMemberIds, _selectedMemberIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      existingEvent,
      const DeepCollectionEquality().hash(_allMembers),
      const DeepCollectionEquality().hash(_selectedMemberIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormLoadedImplCopyWith<_$FormLoadedImpl> get copyWith =>
      __$$FormLoadedImplCopyWithImpl<_$FormLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) {
    return formLoaded(existingEvent, allMembers, selectedMemberIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) {
    return formLoaded?.call(existingEvent, allMembers, selectedMemberIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (formLoaded != null) {
      return formLoaded(existingEvent, allMembers, selectedMemberIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) {
    return formLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) {
    return formLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (formLoaded != null) {
      return formLoaded(this);
    }
    return orElse();
  }
}

abstract class FormLoaded implements AttendanceState {
  const factory FormLoaded(
      {final Attendance? existingEvent,
      required final List<Member> allMembers,
      required final Set<String> selectedMemberIds}) = _$FormLoadedImpl;

  Attendance? get existingEvent; // Null if new
  List<Member> get allMembers;
  Set<String> get selectedMemberIds;
  @JsonKey(ignore: true)
  _$$FormLoadedImplCopyWith<_$FormLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActionSuccessImplCopyWith<$Res> {
  factory _$$ActionSuccessImplCopyWith(
          _$ActionSuccessImpl value, $Res Function(_$ActionSuccessImpl) then) =
      __$$ActionSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ActionSuccessImplCopyWithImpl<$Res>
    extends _$AttendanceStateCopyWithImpl<$Res, _$ActionSuccessImpl>
    implements _$$ActionSuccessImplCopyWith<$Res> {
  __$$ActionSuccessImplCopyWithImpl(
      _$ActionSuccessImpl _value, $Res Function(_$ActionSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ActionSuccessImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ActionSuccessImpl implements ActionSuccess {
  const _$ActionSuccessImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AttendanceState.actionSuccess(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionSuccessImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionSuccessImplCopyWith<_$ActionSuccessImpl> get copyWith =>
      __$$ActionSuccessImplCopyWithImpl<_$ActionSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) {
    return actionSuccess(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) {
    return actionSuccess?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (actionSuccess != null) {
      return actionSuccess(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) {
    return actionSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) {
    return actionSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (actionSuccess != null) {
      return actionSuccess(this);
    }
    return orElse();
  }
}

abstract class ActionSuccess implements AttendanceState {
  const factory ActionSuccess(final String message) = _$ActionSuccessImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ActionSuccessImplCopyWith<_$ActionSuccessImpl> get copyWith =>
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
    extends _$AttendanceStateCopyWithImpl<$Res, _$ErrorImpl>
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

class _$ErrorImpl implements Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AttendanceState.error(message: $message)';
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
    required TResult Function(List<Attendance> history) historyLoaded,
    required TResult Function(Attendance? existingEvent,
            List<Member> allMembers, Set<String> selectedMemberIds)
        formLoaded,
    required TResult Function(String message) actionSuccess,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Attendance> history)? historyLoaded,
    TResult? Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult? Function(String message)? actionSuccess,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Attendance> history)? historyLoaded,
    TResult Function(Attendance? existingEvent, List<Member> allMembers,
            Set<String> selectedMemberIds)?
        formLoaded,
    TResult Function(String message)? actionSuccess,
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
    required TResult Function(HistoryLoaded value) historyLoaded,
    required TResult Function(FormLoaded value) formLoaded,
    required TResult Function(ActionSuccess value) actionSuccess,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(HistoryLoaded value)? historyLoaded,
    TResult? Function(FormLoaded value)? formLoaded,
    TResult? Function(ActionSuccess value)? actionSuccess,
    TResult? Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(HistoryLoaded value)? historyLoaded,
    TResult Function(FormLoaded value)? formLoaded,
    TResult Function(ActionSuccess value)? actionSuccess,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements AttendanceState {
  const factory Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
