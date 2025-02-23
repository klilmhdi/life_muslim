import 'package:flutter/material.dart';

class AppColor {
  final ColorScheme colorScheme;

  AppColor({required this.colorScheme});

  // Light Theme
  factory AppColor.lightTheme() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          primaryContainer: Colors.blue[100],
          onPrimaryContainer: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.black,
          secondaryContainer: Colors.green[100],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.yellow,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.yellow[100],
          onTertiaryContainer: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[100],
          onErrorContainer: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceVariant: Colors.grey[200],
          onSurfaceVariant: Colors.black,
          outline: Colors.grey,
          outlineVariant: Colors.black,
          shadow: Colors.grey[700],
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.blue,
          surfaceTint: Colors.blue[100],
        ));
  }

  // Dark Theme
  factory AppColor.darkTheme() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.deepPurpleAccent,
          onPrimary: Colors.white,
          primaryContainer: Colors.blue[100],
          onPrimaryContainer: Colors.white,
          secondary: Colors.teal,
          onSecondary: Colors.white,
          secondaryContainer: Colors.teal[700],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.amber,
          onTertiary: const Color(0xFF040D12),
          tertiaryContainer: Colors.amber[700],
          onTertiaryContainer: const Color(0xFF040D12),
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[700],
          onErrorContainer: Colors.white,
          background: const Color(0xFF040D12),
          onBackground: Colors.white,
          surface: const Color(0xFF040D12),
          onSurface: Colors.white,
          surfaceVariant: Colors.grey[800],
          onSurfaceVariant: Colors.white,
          outline: Colors.grey,
          outlineVariant: Colors.white,
          shadow: const Color(0xFF040D12),
          scrim: const Color(0xFF040D12).withOpacity(0.5),
          inverseSurface: Colors.white,
          onInverseSurface: const Color(0xFF040D12),
          inversePrimary: Colors.blue,
          surfaceTint: Colors.deepOrange[700],
        ));
  }

  // Theme 3: Light Orange
  factory AppColor.lightTheme3() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.orange,
          onPrimary: Colors.white,
          primaryContainer: Colors.orange[100],
          onPrimaryContainer: Colors.white,
          secondary: Colors.blue,
          onSecondary: Colors.black,
          secondaryContainer: Colors.blue[100],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.blue,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.blue[100],
          onTertiaryContainer: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[100],
          onErrorContainer: Colors.white,
          background: Colors.amber[100]!,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceVariant: Colors.grey[200],
          onSurfaceVariant: Colors.black,
          outline: Colors.grey,
          outlineVariant: Colors.black,
          shadow: Colors.grey[700],
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.orange,
          surfaceTint: Colors.orange[100],
        ));
  }

  // Theme 4: Dark Green
  factory AppColor.darkTheme4() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.green[900]!,
          onPrimary: Colors.white,
          primaryContainer: Colors.green[700],
          onPrimaryContainer: Colors.white,
          secondary: Colors.pink,
          onSecondary: Colors.white,
          secondaryContainer: Colors.pink[700],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.pink,
          onTertiary: Colors.white,
          tertiaryContainer: Colors.pink[700],
          onTertiaryContainer: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[700],
          onErrorContainer: Colors.white,
          background: const Color(0xff3e3939),
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          surfaceVariant: Colors.grey[800],
          onSurfaceVariant: Colors.white,
          outline: Colors.grey,
          outlineVariant: Colors.white,
          shadow: Colors.black,
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.white,
          onInverseSurface: Colors.black,
          inversePrimary: Colors.green,
          surfaceTint: Colors.green[700],
        ));
  }

  // Theme 5: Light Pink
  factory AppColor.lightTheme5() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.pink,
          onPrimary: Colors.white,
          primaryContainer: Colors.pink[100],
          onPrimaryContainer: Colors.white,
          secondary: Colors.yellow,
          onSecondary: Colors.black,
          secondaryContainer: Colors.yellow[100],
          onSecondaryContainer: Colors.black,
          tertiary: Colors.yellow,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.yellow[100],
          onTertiaryContainer: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[100],
          onErrorContainer: Colors.white,
          background: Colors.pink[100]!,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceVariant: Colors.grey[200],
          onSurfaceVariant: Colors.black,
          outline: Colors.grey,
          outlineVariant: Colors.black,
          shadow: Colors.grey[700],
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.pink,
          surfaceTint: Colors.pink[100],
        ));
  }

  // Theme 6: Dark Red
  factory AppColor.darkTheme6() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.red,
          onPrimary: Colors.white,
          primaryContainer: Colors.red[700],
          onPrimaryContainer: Colors.white,
          secondary: Colors.orange,
          onSecondary: Colors.black,
          secondaryContainer: Colors.orange[700],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.orange,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.orange[700],
          onTertiaryContainer: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[700],
          onErrorContainer: Colors.white,
          background: const Color(0xff404040),
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          surfaceVariant: Colors.grey[800],
          onSurfaceVariant: Colors.white,
          outline: Colors.grey,
          outlineVariant: Colors.white,
          shadow: Colors.black,
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.white,
          onInverseSurface: Colors.black,
          inversePrimary: Colors.red,
          surfaceTint: Colors.red[700],
        ));
  }

  // Theme 7: Light Green
  factory AppColor.lightTheme7() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.green,
          onPrimary: Colors.white,
          primaryContainer: Colors.green[100],
          onPrimaryContainer: Colors.white,
          secondary: Colors.teal,
          onSecondary: Colors.black,
          secondaryContainer: Colors.teal[100],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.teal,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.teal[100],
          onTertiaryContainer: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[100],
          onErrorContainer: Colors.white,
          background: Colors.lightGreen[100]!,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceVariant: Colors.grey[200],
          onSurfaceVariant: Colors.black,
          outline: Colors.grey,
          outlineVariant: Colors.black,
          shadow: Colors.grey[700],
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.green,
          surfaceTint: Colors.green[100],
        ));
  }

  // Theme 8: Dark Blue
  factory AppColor.darkTheme8() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.blue,
          onPrimary: Colors.white,
          primaryContainer: Colors.blue[700],
          onPrimaryContainer: Colors.white,
          secondary: Colors.amber,
          onSecondary: Colors.black,
          secondaryContainer: Colors.amber[700],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.amber,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.amber[700],
          onTertiaryContainer: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[700],
          onErrorContainer: Colors.white,
          background: const Color(0xff404040),
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          surfaceVariant: Colors.grey[800],
          onSurfaceVariant: Colors.white,
          outline: Colors.grey,
          outlineVariant: Colors.white,
          shadow: Colors.black,
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.white,
          onInverseSurface: Colors.black,
          inversePrimary: Colors.blue,
          surfaceTint: Colors.blue[700],
        ));
  }

  // Theme 9: Light Purple
  factory AppColor.lightTheme9() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.purple,
          onPrimary: Colors.white,
          primaryContainer: Colors.purple[100],
          onPrimaryContainer: Colors.white,
          secondary: Colors.cyan,
          onSecondary: Colors.black,
          secondaryContainer: Colors.cyan[100],
          onSecondaryContainer: Colors.black,
          tertiary: Colors.cyan,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.cyan[100],
          onTertiaryContainer: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[100],
          onErrorContainer: Colors.white,
          background: Colors.purple[100]!,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceVariant: Colors.grey[200],
          onSurfaceVariant: Colors.black,
          outline: Colors.grey,
          outlineVariant: Colors.black,
          shadow: Colors.grey[700],
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.purple,
          surfaceTint: Colors.purple[100],
        ));
  }

  // Theme 10: Dark Orange
  factory AppColor.darkTheme10() {
    return AppColor(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.orange[900]!,
          onPrimary: Colors.white,
          primaryContainer: Colors.orange[700],
          onPrimaryContainer: Colors.white,
          secondary: Colors.yellow,
          onSecondary: Colors.black,
          secondaryContainer: Colors.yellow[700],
          onSecondaryContainer: Colors.white,
          tertiary: Colors.yellow,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.yellow[700],
          onTertiaryContainer: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          errorContainer: Colors.red[700],
          onErrorContainer: Colors.white,
          background: const Color(0xff404040),
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          surfaceVariant: Colors.grey[800],
          onSurfaceVariant: Colors.white,
          outline: Colors.grey,
          outlineVariant: Colors.white,
          shadow: Colors.black,
          scrim: Colors.black.withOpacity(0.5),
          inverseSurface: Colors.white,
          onInverseSurface: Colors.black,
          inversePrimary: Colors.orange,
          surfaceTint: Colors.orange[700],
        ));
  }

  static List<ColorScheme> availableColorSchemes = [
    AppColor.lightTheme().colorScheme,
    AppColor.darkTheme().colorScheme,
    AppColor.lightTheme3().colorScheme,
    AppColor.darkTheme4().colorScheme,
    AppColor.lightTheme5().colorScheme,
    AppColor.darkTheme6().colorScheme,
    AppColor.lightTheme7().colorScheme,
    AppColor.darkTheme8().colorScheme,
    AppColor.lightTheme9().colorScheme,
    AppColor.darkTheme10().colorScheme,
  ];

  // Color names
  static const String lightThemeColor = 'lightTheme';
  static const String darkThemeColor = 'darkTheme';
  static const String lightTheme3Color = 'lightTheme3';
  static const String darkTheme4Color = 'darkTheme4';
  static const String lightTheme5Color = 'lightTheme5';
  static const String darkTheme6Color = 'darkTheme6';
  static const String lightTheme7Color = 'lightTheme7';
  static const String darkTheme8Color = 'darkTheme8';
  static const String lightTheme9Color = 'lightTheme9';
  static const String darkTheme10Color = 'darkTheme10';

  static ColorScheme getColorSchemeByIndex(int index) {
    if (index >= 0 && index < availableColorSchemes.length) {
      return availableColorSchemes[index];
    }
    return availableColorSchemes[0];
  }

  static int getThemeIndex(ColorScheme colorScheme) {
    return availableColorSchemes.indexOf(colorScheme);
  }

  static List<String> themeNames = [
    'Light Theme',
    'Dark Theme',
    'Light Orange',
    'Dark Green',
    'Light Pink',
    'Dark Red',
    'Light Green',
    'Dark Blue',
    'Light Purple',
    'Dark Orange',
  ];

  static String getThemeName(int index) {
    switch (index) {
      case 0:
        return 'Light Theme';
      case 1:
        return 'Dark Theme';
      case 2:
        return 'Light Orange Theme';
      case 3:
        return 'Dark Green Theme';
      case 4:
        return 'Light Pink Theme';
      case 5:
        return 'Dark Red Theme';
      case 6:
        return 'Light Green Theme';
      case 7:
        return 'Dark Blue Theme';
      case 8:
        return 'Light Purple Theme';
      case 9:
        return 'Dark Orange Theme';
      default:
        return 'Unknown Theme';
    }
  }
}

/*
brightness: تحدد السطوع العام لنظام الألوان، إما Brightness.light للسطوع الفاتح أو Brightness.dark للسطوع الداكن.

primary: اللون الأساسي المستخدم لعناصر واجهة المستخدم البارزة مثل الأزرار والعناصر المحددة.

onPrimary: اللون المستخدم للنص والرموز فوق اللون الأساسي.

primaryContainer: لون اختياري يمكن استخدامه كلون خلفية للعناصر التي تستخدم اللون الأساسي.

onPrimaryContainer: لون اختياري يستخدم كلون للنص والرموز فوق primaryContainer.

secondary: اللون الثانوي المستخدم لعناصر واجهة المستخدم مثل المفاتيح والمؤشرات.

onSecondary: اللون المستخدم للنص والرموز فوق اللون الثانوي.

secondaryContainer: لون اختياري يمكن استخدامه كلون خلفية للعناصر التي تستخدم اللون الثانوي.

onSecondaryContainer: لون اختياري يستخدم كلون للنص والرموز فوق secondaryContainer.

tertiary: لون إضافي يستخدم في تصميم واجهة المستخدم.

onTertiary: اللون المستخدم للنص والرموز فوق اللون الثالثي.

tertiaryContainer: لون اختياري يمكن استخدامه كلون خلفية للعناصر التي تستخدم اللون الثالثي.

onTertiaryContainer: لون اختياري يستخدم كلون للنص والرموز فوق tertiaryContainer.

error: اللون المستخدم لرسائل الخطأ أو العناصر التي تشير إلى وجود خطأ.

onError: اللون المستخدم للنص والرموز فوق اللون الخطأ.

errorContainer: لون اختياري يمكن استخدامه كلون خلفية للعناصر التي تشير إلى وجود خطأ.

onErrorContainer: لون اختياري يستخدم كلون للنص والرموز فوق errorContainer.

background: لون خلفية التطبيق أو واجهة المستخدم.

onBackground: اللون المستخدم للنص والرموز فوق خلفية التطبيق.

surface: لون خلفية العناصر السطحية مثل البطاقات والحوارات.

onSurface: اللون المستخدم للنص والرموز فوق لون السطح.

surfaceVariant: لون اختياري يستخدم لتلوين العناصر المرتفعة مثل الأزرار العائمة.

onSurfaceVariant: لون اختياري يستخدم للنص والرموز فوق surfaceVariant.

outline: اللون المستخدم للحدود والإطارات.

outlineVariant: لون اختياري يستخدم للحدود والإطارات للعناصر المرتفعة.

shadow: لون اختياري يستخدم للظلال.

scrim: لون اختياري يستخدم لتراكب عناصر أخرى مثل الحوارات.

inverseSurface: لون اختياري يستخدم للأسطح المقلوبة مثل العناصر المحددة.

onInverseSurface: لون اختياري يستخدم للنص والرموز فوق inverseSurface.

inversePrimary: لون اختياري يستخدم للعناصر الأساسية المقلوبة مثل الأزرار المحددة.

surfaceTint: لون اختياري يستخدم لتظليل الأسطح مثل البطاقات.
* */
class FormatColor {
  static const Color keyword = Colors.blue;
  static const Color string = Colors.green;
  static const Color comment = Colors.grey;
  static const Color number = Colors.orange;
  static const Color dataType = Colors.purple; // New color for data types
  static const Color classColor = Colors.teal; // New color for classes
  static const Color methodColor = Colors.indigo; // New color for methods/functions
}