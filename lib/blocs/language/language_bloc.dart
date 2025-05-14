import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String languageCode;
  ChangeLanguage(this.languageCode);
}

// State
class LanguageState {
  final Locale locale;

  const LanguageState({required this.locale});

  LanguageState copyWith({Locale? locale}) {
    return LanguageState(
      locale: locale ?? this.locale,
    );
  }
}

// BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences preferences;
  static const String _languageKey = 'language_code';
  static const String _defaultLanguage = 'ru';

  LanguageBloc(this.preferences)
      : super(LanguageState(
          locale: Locale(
            preferences.getString(_languageKey) ?? _defaultLanguage,
          ),
        )) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    await preferences.setString(_languageKey, event.languageCode);
    emit(state.copyWith(locale: Locale(event.languageCode)));
  }
} 