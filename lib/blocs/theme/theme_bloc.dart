// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './theme_event.dart';
import './theme_state.dart';

// Events
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetTheme extends ThemeEvent {
  final ThemeMode themeMode;
  SetTheme(this.themeMode);
}

// State
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _preferences;
  final String _themeKey = 'themeMode';

  ThemeBloc(this._preferences)
      : super(ThemeState(
          themeMode: ThemeMode.values[
              _preferences.getInt('themeMode') ?? ThemeMode.system.index],
        )) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _preferences.setInt(_themeKey, newThemeMode.index);
    emit(ThemeState(themeMode: newThemeMode));
  }

  Future<void> _onSetTheme(SetTheme event, Emitter<ThemeState> emit) async {
    await _preferences.setInt(_themeKey, event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }
} 