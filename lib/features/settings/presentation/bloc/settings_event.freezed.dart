// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function(String userName, String churchName)
        updateIdentity,
    required TResult Function() toggleDailyVerse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function(String userName, String churchName)? updateIdentity,
    TResult? Function()? toggleDailyVerse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function(String userName, String churchName)? updateIdentity,
    TResult Function()? toggleDailyVerse,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) loadSettings,
    required TResult Function(UpdateIdentity value) updateIdentity,
    required TResult Function(ToggleDailyVerse value) toggleDailyVerse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? loadSettings,
    TResult? Function(UpdateIdentity value)? updateIdentity,
    TResult? Function(ToggleDailyVerse value)? toggleDailyVerse,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? loadSettings,
    TResult Function(UpdateIdentity value)? updateIdentity,
    TResult Function(ToggleDailyVerse value)? toggleDailyVerse,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEventCopyWith<$Res> {
  factory $SettingsEventCopyWith(
          SettingsEvent value, $Res Function(SettingsEvent) then) =
      _$SettingsEventCopyWithImpl<$Res, SettingsEvent>;
}

/// @nodoc
class _$SettingsEventCopyWithImpl<$Res, $Val extends SettingsEvent>
    implements $SettingsEventCopyWith<$Res> {
  _$SettingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadSettingsImplCopyWith<$Res> {
  factory _$$LoadSettingsImplCopyWith(
          _$LoadSettingsImpl value, $Res Function(_$LoadSettingsImpl) then) =
      __$$LoadSettingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$LoadSettingsImpl>
    implements _$$LoadSettingsImplCopyWith<$Res> {
  __$$LoadSettingsImplCopyWithImpl(
      _$LoadSettingsImpl _value, $Res Function(_$LoadSettingsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadSettingsImpl implements LoadSettings {
  const _$LoadSettingsImpl();

  @override
  String toString() {
    return 'SettingsEvent.loadSettings()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadSettingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function(String userName, String churchName)
        updateIdentity,
    required TResult Function() toggleDailyVerse,
  }) {
    return loadSettings();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function(String userName, String churchName)? updateIdentity,
    TResult? Function()? toggleDailyVerse,
  }) {
    return loadSettings?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function(String userName, String churchName)? updateIdentity,
    TResult Function()? toggleDailyVerse,
    required TResult orElse(),
  }) {
    if (loadSettings != null) {
      return loadSettings();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) loadSettings,
    required TResult Function(UpdateIdentity value) updateIdentity,
    required TResult Function(ToggleDailyVerse value) toggleDailyVerse,
  }) {
    return loadSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? loadSettings,
    TResult? Function(UpdateIdentity value)? updateIdentity,
    TResult? Function(ToggleDailyVerse value)? toggleDailyVerse,
  }) {
    return loadSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? loadSettings,
    TResult Function(UpdateIdentity value)? updateIdentity,
    TResult Function(ToggleDailyVerse value)? toggleDailyVerse,
    required TResult orElse(),
  }) {
    if (loadSettings != null) {
      return loadSettings(this);
    }
    return orElse();
  }
}

abstract class LoadSettings implements SettingsEvent {
  const factory LoadSettings() = _$LoadSettingsImpl;
}

/// @nodoc
abstract class _$$UpdateIdentityImplCopyWith<$Res> {
  factory _$$UpdateIdentityImplCopyWith(_$UpdateIdentityImpl value,
          $Res Function(_$UpdateIdentityImpl) then) =
      __$$UpdateIdentityImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userName, String churchName});
}

/// @nodoc
class __$$UpdateIdentityImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$UpdateIdentityImpl>
    implements _$$UpdateIdentityImplCopyWith<$Res> {
  __$$UpdateIdentityImplCopyWithImpl(
      _$UpdateIdentityImpl _value, $Res Function(_$UpdateIdentityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? churchName = null,
  }) {
    return _then(_$UpdateIdentityImpl(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      churchName: null == churchName
          ? _value.churchName
          : churchName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpdateIdentityImpl implements UpdateIdentity {
  const _$UpdateIdentityImpl(
      {required this.userName, required this.churchName});

  @override
  final String userName;
  @override
  final String churchName;

  @override
  String toString() {
    return 'SettingsEvent.updateIdentity(userName: $userName, churchName: $churchName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateIdentityImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.churchName, churchName) ||
                other.churchName == churchName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userName, churchName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateIdentityImplCopyWith<_$UpdateIdentityImpl> get copyWith =>
      __$$UpdateIdentityImplCopyWithImpl<_$UpdateIdentityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function(String userName, String churchName)
        updateIdentity,
    required TResult Function() toggleDailyVerse,
  }) {
    return updateIdentity(userName, churchName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function(String userName, String churchName)? updateIdentity,
    TResult? Function()? toggleDailyVerse,
  }) {
    return updateIdentity?.call(userName, churchName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function(String userName, String churchName)? updateIdentity,
    TResult Function()? toggleDailyVerse,
    required TResult orElse(),
  }) {
    if (updateIdentity != null) {
      return updateIdentity(userName, churchName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) loadSettings,
    required TResult Function(UpdateIdentity value) updateIdentity,
    required TResult Function(ToggleDailyVerse value) toggleDailyVerse,
  }) {
    return updateIdentity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? loadSettings,
    TResult? Function(UpdateIdentity value)? updateIdentity,
    TResult? Function(ToggleDailyVerse value)? toggleDailyVerse,
  }) {
    return updateIdentity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? loadSettings,
    TResult Function(UpdateIdentity value)? updateIdentity,
    TResult Function(ToggleDailyVerse value)? toggleDailyVerse,
    required TResult orElse(),
  }) {
    if (updateIdentity != null) {
      return updateIdentity(this);
    }
    return orElse();
  }
}

abstract class UpdateIdentity implements SettingsEvent {
  const factory UpdateIdentity(
      {required final String userName,
      required final String churchName}) = _$UpdateIdentityImpl;

  String get userName;
  String get churchName;
  @JsonKey(ignore: true)
  _$$UpdateIdentityImplCopyWith<_$UpdateIdentityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToggleDailyVerseImplCopyWith<$Res> {
  factory _$$ToggleDailyVerseImplCopyWith(_$ToggleDailyVerseImpl value,
          $Res Function(_$ToggleDailyVerseImpl) then) =
      __$$ToggleDailyVerseImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleDailyVerseImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$ToggleDailyVerseImpl>
    implements _$$ToggleDailyVerseImplCopyWith<$Res> {
  __$$ToggleDailyVerseImplCopyWithImpl(_$ToggleDailyVerseImpl _value,
      $Res Function(_$ToggleDailyVerseImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ToggleDailyVerseImpl implements ToggleDailyVerse {
  const _$ToggleDailyVerseImpl();

  @override
  String toString() {
    return 'SettingsEvent.toggleDailyVerse()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ToggleDailyVerseImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadSettings,
    required TResult Function(String userName, String churchName)
        updateIdentity,
    required TResult Function() toggleDailyVerse,
  }) {
    return toggleDailyVerse();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadSettings,
    TResult? Function(String userName, String churchName)? updateIdentity,
    TResult? Function()? toggleDailyVerse,
  }) {
    return toggleDailyVerse?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadSettings,
    TResult Function(String userName, String churchName)? updateIdentity,
    TResult Function()? toggleDailyVerse,
    required TResult orElse(),
  }) {
    if (toggleDailyVerse != null) {
      return toggleDailyVerse();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) loadSettings,
    required TResult Function(UpdateIdentity value) updateIdentity,
    required TResult Function(ToggleDailyVerse value) toggleDailyVerse,
  }) {
    return toggleDailyVerse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? loadSettings,
    TResult? Function(UpdateIdentity value)? updateIdentity,
    TResult? Function(ToggleDailyVerse value)? toggleDailyVerse,
  }) {
    return toggleDailyVerse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? loadSettings,
    TResult Function(UpdateIdentity value)? updateIdentity,
    TResult Function(ToggleDailyVerse value)? toggleDailyVerse,
    required TResult orElse(),
  }) {
    if (toggleDailyVerse != null) {
      return toggleDailyVerse(this);
    }
    return orElse();
  }
}

abstract class ToggleDailyVerse implements SettingsEvent {
  const factory ToggleDailyVerse() = _$ToggleDailyVerseImpl;
}
