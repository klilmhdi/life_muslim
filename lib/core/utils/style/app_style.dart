import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../color/app_colors.dart';

class AppStyle {
  final int themeIndex;

  AppStyle({this.themeIndex = 0});

  ThemeData get currentTheme {
    if (themeIndex >= 0 && themeIndex < AppThemeColor.availableColorSchemes.length) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: AppThemeColor.availableColorSchemes[themeIndex],
        fontFamily: AppConsts.tajawal
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        colorScheme: AppThemeColor.availableColorSchemes[0],
          fontFamily: AppConsts.tajawal
      );
    }
  }
}