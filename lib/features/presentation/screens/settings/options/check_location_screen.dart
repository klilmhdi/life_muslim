import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

class LocationSettingsScreen extends StatefulWidget {
  const LocationSettingsScreen({super.key});

  @override
  State<LocationSettingsScreen> createState() => _LocationSettingsScreenState();
}

class _LocationSettingsScreenState extends State<LocationSettingsScreen> {
  String _latitude = 'غير متوفر';
  String _longitude = 'غير متوفر';
  String _city = 'غير متوفر';
  String _country = 'غير متوفر';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    try {
      final location = await SharedPrefController.getLocation();
      if (mounted) {
        setState(() {
          _latitude = location['latitude'].toString();
          _longitude = location['longitude'].toString();
          _city = location['city'].toString();
          _country = location['country'].toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load location: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الموقع')),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationSaved) {
            _loadSavedLocation();
            showCustomSnackBar(
              context: context,
              title: 'تم تحديث الموقع بنجاح.',
              duration: 3,
              type: MessageType.success,
            );
          } else if (state is LocationError) {
            showCustomSnackBar(
              context: context,
              title: 'خطأ في تحديث الموقع: ${state.message}',
              duration: 3,
              type: MessageType.error,
            );
          } else if (state is LocationPermissionDenied || state is LocationPermissionPermanentlyDenied) {
            showCustomSnackBar(context: context, title: "حاول مرة آخرى", duration: 3, type: MessageType.error);
          }
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Center(
                  child: Column(
                      children: [
                        Text('خط العرض (Latitude): $_latitude'),
                        const SizedBox(height: 8),
                        Text('خط الطول (Longitude): $_longitude'),
                        const SizedBox(height: 8),
                        Text('المدينة: $_city'),
                        const SizedBox(height: 8),
                        Text('الدولة: $_country'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<LocationBloc>().add(RefreshLocationEvent());
                          },
                          child: const Text('تحديث الموقع الحالي (عبر الإنترنت)'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<LocationBloc>().add(RequestLocationPermissionEvent());
                          },
                          child: const Text('طلب موقع جديد (إعادة طلب الإذن)'),
                        ),
                      ],
                    ),
                ),
      ),
    );
  }
}
