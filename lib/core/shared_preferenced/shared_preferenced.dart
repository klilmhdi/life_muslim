import 'dart:convert';

import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/pr_keys_enum.dart';

class SharedPrefController {
  SharedPrefController._();

  SharedPreferences? _sharedPreferences;
  static SharedPrefController? _instance;

  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';
  static const String _bookmarksKey = 'bookmarks';
  static const String _tasbeehCounterPrefix = 'tasbeeh_counter_';

  factory SharedPrefController() => _instance ??= SharedPrefController._();

  Future<void> initPreferences() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  T? getValueFor<T>(String key) {
    if (_sharedPreferences == null) {
      throw Exception("SharedPreferences has not been initialized. Call initPreferences() first.");
    }
    if (_sharedPreferences!.containsKey(key)) {
      return _sharedPreferences!.get(key) as T;
    }
    return null;
  }

  //=========================> Save latitude and longitude
  static Future<void> saveLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latitudeKey, latitude);
    await prefs.setDouble(_longitudeKey, longitude);
  }

  //=========================> Get latitude and longitude
  static Future<Map<String, double>> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_latitudeKey);
    final longitude = prefs.getDouble(_longitudeKey);
    return {
      'latitude': latitude ?? 0.0,
      'longitude': longitude ?? 0.0,
    };
  }

  //=========================> Set the Language
  Future<bool> setLanguageCode({required String langCode}) async =>
      await _sharedPreferences!.setString(PrKeys.languageCode.name, langCode);

  //=========================> Set the Theme
  Future<bool> setTheme({required int themeCurrentIndex}) async =>
      await _sharedPreferences!.setInt(PrKeys.themeCurrentIndex.name, themeCurrentIndex);

  Future<bool> setString({
    required String key,
    required String value,
  }) async =>
      await _sharedPreferences!.setString(key, value);

  void clear() async => _sharedPreferences!.clear();

  Future<bool> setIsLogin({required bool value}) async =>
      await _sharedPreferences!.setBool(PrKeys.isLogin.name, value);

  Future<bool> setMenuCurrentIndex({required int index}) async =>
      await _sharedPreferences!.setInt(PrKeys.menuCurrentIndex.name, index);

  Future<bool> setFlutterSdk({required String flutterSdkPath}) async {
    return await _sharedPreferences!.setString(PrKeys.flutterSdkPath.name, flutterSdkPath);
  }

  /// **حفظ العلامة المرجعية مع اسم السورة**
  static Future<void> saveBookmark(String surahName, AyahsModel ayah) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];

    // ✅ حفظ اسم السورة مع بيانات الآية
    final Map<String, dynamic> bookmarkData = {
      "surahName": surahName,
      "ayah": ayah.toJson(),
    };

    final String bookmarkJsonString = jsonEncode(bookmarkData);

    if (!bookmarks.contains(bookmarkJsonString)) {
      bookmarks.add(bookmarkJsonString);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarks = prefs.getStringList(_bookmarksKey);

    if (bookmarks == null) return [];

    return bookmarks.map((bookmarkJsonString) {
      final Map<String, dynamic>? decodedJson = jsonDecode(bookmarkJsonString);

      if (decodedJson == null || !decodedJson.containsKey("ayah")) {
        return <String, dynamic>{}; // ✅ تأمين ضد البيانات الفارغة أو غير الصحيحة
      }

      return {
        "surahName": decodedJson["surahName"] ?? "Unknown Surah",
        "ayah": AyahsModel.fromJson(decodedJson["ayah"]),
      };
    }).where((bookmark) => bookmark.isNotEmpty).toList(); // ✅ استبعاد العناصر الفارغة
  }

  /// **حذف العلامة المرجعية**
  static Future<void> removeBookmark(String surahName, AyahsModel ayah) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];

    final Map<String, dynamic> bookmarkData = {
      "surahName": surahName,
      "ayah": ayah.toJson(),
    };

    final String bookmarkJsonString = jsonEncode(bookmarkData);

    bookmarks.remove(bookmarkJsonString);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  // حفظ العداد لتسبيح معين
  static Future<void> saveTasbeehCounter(String tasbeeh, int counter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_tasbeehCounterPrefix$tasbeeh', counter);
  }

  // استرجاع العداد لتسبيح معين
  static Future<int> getTasbeehCounter(String tasbeeh) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_tasbeehCounterPrefix$tasbeeh') ?? 0;
  }

  // حذف العداد لتسبيح معين
  static Future<void> deleteTasbeehCounter(String tasbeeh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_tasbeehCounterPrefix$tasbeeh');
  }
}
