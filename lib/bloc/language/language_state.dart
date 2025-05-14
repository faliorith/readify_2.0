import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  String get language => locale.languageCode;

  @override
  List<Object?> get props => [locale];
} 