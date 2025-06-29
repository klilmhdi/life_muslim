import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/data/models/quran/surah_model.dart';
import '../enums/pr_keys_enum.dart';

class SharedPrefController {
  SharedPrefController._();

  SharedPreferences? _sharedPreferences;
  static SharedPrefController? _instance;

  // private keys
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';
  static const String _cityKey = 'city';
  static const String _countryKey = 'country';
  static const String _bookmarksKey = 'bookmarks';
  static const String _bookmarkPagesKey = 'bookmark_pages';
  static const String _tasbeehCounterPrefix = 'tasbeeh_counter_';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationsDialogShownKey = 'notifications_dialog_shown';

  //=========================> Initialize SharedPreferenceController
  factory SharedPrefController() => _instance ??= SharedPrefController._();

  Future<void> initPreferences() async => _sharedPreferences = await SharedPreferences.getInstance();

  T? getValueFor<T>(String key) {
    if (_sharedPreferences == null) {
      throw Exception("SharedPreferences has not been initialized. Call initPreferences() first.");
    }
    if (_sharedPreferences!.containsKey(key)) {
      final value = _sharedPreferences!.get(key);
      if (value is T) {
        return value;
      } else {
        debugPrint("⚠️ Type mismatch for key '$key'. Stored: ${value.runtimeType}, Expected: $T");
      }
    }
    return null;
  }

  Future<bool> setBool({required String key, required bool value}) async =>
      await _sharedPreferences!.setBool(key, value);

  ///=========================> Location service in SharedPreference
  //=========================> - Save latitude and longitude, city, and country
  static Future<void> saveLocationData(double latitude, double longitude, String city, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latitudeKey, latitude);
    await prefs.setDouble(_longitudeKey, longitude);
    await prefs.setString(_cityKey, city);
    await prefs.setString(_countryKey, country);
  }

  //=========================> - Save latitude and longitude (with geocoding)
  static Future<void> saveLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      final Placemark place = placemarks.first;
      final String city = place.locality ?? place.administrativeArea ?? "";
      final String country = place.country ?? "";

      await saveLocationData(latitude, longitude, city, country);
    } catch (e, s) {
      debugPrint("Error getting location info: $e");
      debugPrint("Error getting location info: $s");
    }
  }

  //=========================> - Get latitude and longitude
  static Future<Map<String, dynamic>> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_latitudeKey);
    final longitude = prefs.getDouble(_longitudeKey);
    final city = prefs.getString(_cityKey);
    final country = prefs.getString(_countryKey);
    return {
      'latitude': latitude ?? 0.0,
      'longitude': longitude ?? 0.0,
      'city': city ?? "Empty",
      'country': country ?? "Empty",
    };
  }

  ///=========================> Language in SharedPreference
  Future<bool> setLanguageCode({required String langCode}) async =>
      await _sharedPreferences!.setString(PrKeys.languageCode.name, langCode);

  ///=========================> Themes in SharedPreference
  Future<bool> setTheme({required int themeCurrentIndex}) async =>
      await _sharedPreferences!.setInt(PrKeys.themeCurrentIndex.name, themeCurrentIndex);

  Future<bool> setString({required String key, required String value}) async =>
      await _sharedPreferences!.setString(key, value);

  void clear() async => _sharedPreferences!.clear();

  ///=========================> Bookmark service in SharedPreference
  //=========================> - Set (Save) Bookmark for ayahs
  static Future<void> saveBookmark({
    required SurahModel quranModel,
    required String surahName,
    required List<AyahsModel> ayahs,
    required AyahsModel selectedAyah,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];

    final Map<String, dynamic> bookmarkData = {
      "quranModel": quranModel.toJson(),
      "surahName": surahName,
      "ayahs": ayahs.map((ayah) => ayah.toJson()).toList(),
      "selectedAyah": selectedAyah.toJson(),
      "ayahNumber": selectedAyah.numberInSurah,
      "page": selectedAyah.page,
      "juz": selectedAyah.juz,
      "hizbQuarter": selectedAyah.hizbQuarter,
    };

    final String bookmarkJsonString = jsonEncode(bookmarkData);

    // Check if bookmark already exists
    final exists = bookmarks.any((bm) {
      final decoded = jsonDecode(bm);
      return decoded['surahName'] == surahName && decoded['ayahNumber'] == selectedAyah.numberInSurah;
    });

    if (!exists) {
      bookmarks.add(bookmarkJsonString);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  //=========================> - Get Bookmarks for ayahs
  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarks = prefs.getStringList(_bookmarksKey);

    if (bookmarks == null) return [];

    return bookmarks
        .map((bookmarkJsonString) {
          try {
            final decodedJson = jsonDecode(bookmarkJsonString);

            return {
              "quranModel": SurahModel.fromJson(decodedJson["quranModel"] ?? {}),
              "surahName": decodedJson["surahName"],
              "ayahs": (decodedJson["ayahs"] as List).map((ayahJson) => AyahsModel.fromJson(ayahJson)).toList(),
              "selectedAyah": AyahsModel.fromJson(decodedJson["selectedAyah"]),
              "ayahNumber": decodedJson["ayahNumber"],
              "page": decodedJson["page"],
              "juz": decodedJson["juz"],
              "hizbQuarter": decodedJson["hizbQuarter"],
            };
          } catch (e) {
            print("Error decoding bookmark: $e");
            return <String, dynamic>{};
          }
        })
        .where((bookmark) => bookmark.isNotEmpty)
        .toList();
  }

  //=========================> - Remove (Delete) Bookmark for ayahs
  static Future<void> removeBookmark(String surahName, int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];

    bookmarks.removeWhere((bookmarkJsonString) {
      try {
        final decodedJson = jsonDecode(bookmarkJsonString);
        return decodedJson["surahName"] == surahName && decodedJson["ayahNumber"] == ayahNumber;
      } catch (e) {
        print("Error checking bookmark for removal: $e");
        return false;
      }
    });

    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  //=========================> - Check the Bookmarks for ayahs
  static Future<bool> isBookmarked(String surahName, int ayahNumber) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((bookmark) => bookmark["surahName"] == surahName && bookmark["ayahNumber"] == ayahNumber);
  }

  //=========================> - Save a bookmarked page
  static Future<void> saveBookmarkedPage(int juzNumber, int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_bookmarkPagesKey}_$juzNumber';
    await prefs.setInt(key, pageNumber);
  }

  //=========================> - Get a bookmarked page
  static Future<int?> getBookmarkedPage(int juzNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_bookmarkPagesKey}_$juzNumber';
    return prefs.getInt(key);
  }

  //=========================> - Remove a bookmarked page
  static Future<void> removeBookmarkedPage(int juzNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_bookmarkPagesKey}_$juzNumber';
    await prefs.remove(key);
  }

  //=========================> - Check if the current page is bookmarked
  static Future<bool> isPageBookmarked(int juzNumber, int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_bookmarkPagesKey}_$juzNumber';
    final savedPage = prefs.getInt(key);
    return savedPage == pageNumber;
  }

  ///=========================> Tasbeeh service in SharedPreference
  //=========================> - Save tasbeeh
  static Future<void> saveTasbeehCounter(String tasbeeh, int counter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_tasbeehCounterPrefix$tasbeeh', counter);
  }

  //=========================> - Get tasbeeh
  static Future<int> getTasbeehCounter(String tasbeeh) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_tasbeehCounterPrefix$tasbeeh') ?? 0;
  }

  //=========================> - Delete tasbeeh (Restart)
  static Future<void> deleteTasbeehCounter(String tasbeeh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_tasbeehCounterPrefix$tasbeeh');
  }

  ///=========================> LocalNotification services
  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  Future<bool> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_notificationsEnabledKey, value);
  }

  Future<bool> isNotificationsDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsDialogShownKey) ?? false;
  }

  Future<bool> setNotificationsDialogShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_notificationsDialogShownKey, value);
  }
}
