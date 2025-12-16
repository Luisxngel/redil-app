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
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    // Retaining keys for consistency or switching to user suggested?
    // User suggested specific keys in the prompt. I will use them to match instructions.
    final userName = _prefs.getString('userName') ?? 'Pastor';
    final churchName = _prefs.getString('churchName') ?? 'Redil Dashboard';
    
    // Using default constructor since State is a single class
    emit(SettingsState(userName: userName, churchName: churchName, isLoading: false));
  }

  Future<void> _onUpdateIdentity(UpdateIdentity event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    await _prefs.setString('userName', event.userName);
    await _prefs.setString('churchName', event.churchName);
    
    emit(SettingsState(
      userName: event.userName,
      churchName: event.churchName,
      isLoading: false,
    ));
  }
}
