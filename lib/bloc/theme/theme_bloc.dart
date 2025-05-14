import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './theme_event.dart';
import './theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _preferences;
  final String _themeKey = 'isDarkMode';

  ThemeBloc({required SharedPreferences preferences})
      : _preferences = preferences,
        super(ThemeState(isDarkMode: preferences.getBool('isDarkMode') ?? false)) {
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newIsDarkMode = !state.isDarkMode;
    await _preferences.setBool(_themeKey, newIsDarkMode);
    emit(ThemeState(isDarkMode: newIsDarkMode));
  }
} 