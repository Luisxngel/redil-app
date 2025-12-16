import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_event.freezed.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = LoadSettings;
  const factory SettingsEvent.updateIdentity({
    required String userName, 
    required String churchName,
  }) = UpdateIdentity;
  const factory SettingsEvent.toggleDailyVerse() = ToggleDailyVerse; // NEW
}
