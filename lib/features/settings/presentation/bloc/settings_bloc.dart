import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;

  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateIdentity>(_onUpdateIdentity);
    on<ToggleDailyVerse>(_onToggleDailyVerse);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final userName = _prefs.getString('userName') ?? 'Pastor';
    final churchName = _prefs.getString('churchName') ?? 'Redil Dashboard';
    final showDailyVerse = _prefs.getBool('showDailyVerse') ?? false; // Default false
    
    emit(SettingsState(
      userName: userName, 
      churchName: churchName, 
      showDailyVerse: showDailyVerse,
      isLoading: false
    ));
  }

  Future<void> _onUpdateIdentity(UpdateIdentity event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _prefs.setString('userName', event.userName);
    await _prefs.setString('churchName', event.churchName);
    
    emit(state.copyWith(
      userName: event.userName,
      churchName: event.churchName,
      isLoading: false,
    ));
  }

  Future<void> _onToggleDailyVerse(ToggleDailyVerse event, Emitter<SettingsState> emit) async {
    // No explicit loading state needed for a simple toggle
    final newValue = !state.showDailyVerse;
    await _prefs.setBool('showDailyVerse', newValue);
    emit(state.copyWith(showDailyVerse: newValue));
  }
}
