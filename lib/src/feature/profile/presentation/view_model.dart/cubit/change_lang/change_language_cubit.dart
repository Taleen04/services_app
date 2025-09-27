import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/database/cache/shared_pref_helper.dart';
import 'package:trasport_ai/src/core/go_route/go_route.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_lang/change_language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageInitial(Locale('en')));

  void changeLanguage(Locale locale) {
    SharedPrefHelper.setData(StorageKeys.language, locale.languageCode);
    emit(LanguageChanged(locale));
  }

  void loadSavedLanguage() {
    final code = SharedPrefHelper.getString(StorageKeys.language);
    if (code.isNotEmpty) {
      emit(LanguageChanged(Locale(code)));
    } else {
      emit(const LanguageChanged(Locale('en'))); 
    }
  }
}
