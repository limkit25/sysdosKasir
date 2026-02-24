import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = _prefs.getBool('is_dark');
    if (isDark != null) {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } else {
      emit(ThemeMode.light); // Default to Light theme as requested
    }
  }

  void toggleTheme(bool isDark) {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    _prefs.setBool('is_dark', isDark);
  }
}
