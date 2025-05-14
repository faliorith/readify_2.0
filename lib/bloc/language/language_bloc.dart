import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './language_event.dart';
import './language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences _preferences;
  final String _languageKey = 'language';

  LanguageBloc(this._preferences)
      : super(LanguageState(
          locale: Locale(_preferences.getString('language') ?? 'ru'),
        )) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    await _preferences.setString(_languageKey, event.language);
    emit(LanguageState(locale: Locale(event.language)));
  }
} 