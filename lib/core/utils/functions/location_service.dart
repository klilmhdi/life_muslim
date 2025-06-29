import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';

class LocationLocator {
  Future<Map<String, dynamic>?> checkLocationPermissionAndSave() async {
    try {
      // 1. تحقق من حالة الخدمة أولاً
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      // 2. طلب الإذن
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await openAppSettings();
        return null;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return null;
        }
      }

      // 3. جلب الموقع بدقة عالية مع مهلة انتظار
      final position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException("استغرقت عملية جلب الموقع وقتاً طويلاً");
      });

      // 4. حفظ الموقع وعنوانه
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).catchError((_) => []);

      Placemark place = placemarks.isNotEmpty ? placemarks.first : const Placemark();
      final String city = place.administrativeArea ?? "غير معروف";

      /// the result is SanStifano
      final String country = place.country ?? "غير معروف";
      /*
      Add these variables
      final String street = place.street ?? "غير معروف";
      final String gov = place.locality ?? "غير معروف";
      */

      await SharedPrefController.saveLocationData(
        position.latitude,
        position.longitude,
        city,
        country,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': city,
        'country': country,
      };
    } catch (e) {
      print("Location Error: $e");
      return null;
    }
  }

  /// بتشيك الإحداثيات من SharedPreferences
  Future<Map<String, dynamic>?> fetchSavedLocation() async => await SharedPrefController.getLocation();
}
