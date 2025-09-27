import 'package:flutter/material.dart';

abstract class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class LanguageInitial extends LanguageState {
  const LanguageInitial(Locale locale) : super(locale);
}

class LanguageChanged extends LanguageState {
  const LanguageChanged(Locale locale) : super(locale);
}
