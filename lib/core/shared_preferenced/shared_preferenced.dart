import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
