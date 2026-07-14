import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/features/language/state/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit()
      : super(
          const LanguageState(
            locale: Locale('en'),
          ),
        );

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    final code =
        prefs.getString('language_code') ??
            'en';

    emit(
      LanguageState(
        locale: Locale(code),
      ),
    );
  }

  Future<void> changeLanguage(
    String code,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'language_code',
      code,
    );

    emit(
      LanguageState(
        locale: Locale(code),
      ),
    );

  print(
    "Current state => ${state.locale.languageCode}",
  );
  }
}