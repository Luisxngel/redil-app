import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum AppThemeCandidate { blue, teal, purple, orange, dark }

@singleton
class ThemeCubit extends Cubit<AppThemeCandidate> {
  ThemeCubit() : super(AppThemeCandidate.blue);

  void changeTheme(AppThemeCandidate theme) {
    emit(theme);
  }
}
