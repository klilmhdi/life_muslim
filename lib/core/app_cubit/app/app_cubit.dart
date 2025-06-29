import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../enums/pr_keys_enum.dart';
import '../../shared_preferenced/shared_preferenced.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  ///========================================> Theme Color
  ColorScheme themeColorScheme(context) => Theme.of(context).colorScheme;

  ///====================================================> Language
  Future<void> setLanguage({required String? languageCode}) async {
    if (languageCode == null) {
      emit(state.copyWith(
        languageCode: SharedPrefController().getValueFor(PrKeys.languageCode.name),
      ));
    } else {
      SharedPrefController().setLanguageCode(langCode: languageCode).then((value) {
        emit(state.copyWith(
          languageCode: languageCode,
        ));
      });
    }
  }

  ///==================================================>

  Future<void> setThemeIndex({required int? themeIndex}) async {
    if (themeIndex == null) {
      emit(state.copyWith(
        themeCurrentIndex: SharedPrefController().getValueFor(PrKeys.themeCurrentIndex.name),
      ));
    } else {
      SharedPrefController().setTheme(themeCurrentIndex: themeIndex).then((value) {
        emit(state.copyWith(
          themeCurrentIndex: themeIndex,
        ));
      });
    }
  }
}
