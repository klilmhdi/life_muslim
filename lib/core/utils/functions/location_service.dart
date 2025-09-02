import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';

class LocationLocator {
  Future<Map<String, dynamic>?> checkLocationPermissionAndSave() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

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

      final position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 20),
          onTimeout: () => throw TimeoutException("استغرقت عملية جلب الموقع وقتاً طويلاً"));

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks.isNotEmpty ? placemarks.first : const Placemark();
      final String city = place.administrativeArea ?? "غير معروف";

      final String country = place.country ?? "غير معروف";
      await SharedPrefController.saveLocationData(position.latitude, position.longitude, city, country);

      return {'latitude': position.latitude, 'longitude': position.longitude, 'city': city, 'country': country};
    } catch (e) {
      print("Location Error: $e");
      return null;
    }
  }

  /// بتشيك الإحداثيات من SharedPreferences
  Future<Map<String, dynamic>?> fetchSavedLocation() async => await SharedPrefController.getLocation();
}
