import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum AppThemeCandidate { teal, blue, purple, dark }

@singleton
class ThemeCubit extends Cubit<AppThemeCandidate> {
  ThemeCubit() : super(AppThemeCandidate.teal);

  void changeTheme(AppThemeCandidate theme) {
    emit(theme);
  }
}
