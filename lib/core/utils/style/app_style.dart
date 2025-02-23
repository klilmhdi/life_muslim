import 'package:flutter/material.dart';

import '../color/app_colors.dart';

class AppStyle {
  final int themeIndex;

  AppStyle({this.themeIndex = 0});

  ThemeData get currentTheme {
    if (themeIndex >= 0 && themeIndex < AppColor.availableColorSchemes.length) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: AppColor.availableColorSchemes[themeIndex],
        fontFamily: 'Tajawal'
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        colorScheme: AppColor.availableColorSchemes[0],
          fontFamily: 'Tajawal'
      );
    }
  }
}