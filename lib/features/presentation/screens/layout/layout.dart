import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_intro_card_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_layout_card_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_menu/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool _locationPermissionGranted = false;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _prefs = await SharedPreferences.getInstance();
    _permissionStatus = await Permission.locationWhenInUse.status;

    if (_permissionStatus == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _prefs.setBool('locationPermissionGranted', true);
      _fetchAndSaveLocation();
    } else if (_permissionStatus == PermissionStatus.denied ||
        _permissionStatus == PermissionStatus.permanentlyDenied) {
      _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _prefs.setBool('locationPermissionGranted', true);
      _fetchAndSaveLocation(); // Fetch and save location
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required for Qibla and Athan.')),
      );
    }
  }

  Future<void> _fetchAndSaveLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      await SharedPrefController.saveLocation(position.latitude, position.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          buildAppBar(context, title: "حياة المسلم", color: CupertinoColors.white, isLeading: true),
      drawer: customDrawer(context),
      body: Column(
        children: [
          const Expanded(flex: 2, child: IntroCardWidget()),
          Expanded(flex: 4, child: LayoutCardWidget()),
        ],
      ),
    );
  }
}
