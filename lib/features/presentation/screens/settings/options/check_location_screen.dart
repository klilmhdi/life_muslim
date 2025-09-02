import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

import '../../../../../core/utils/consts/app_consts.dart';

class LocationSettingsScreen extends StatefulWidget {
  const LocationSettingsScreen({super.key});

  @override
  State<LocationSettingsScreen> createState() => _LocationSettingsScreenState();
}

class _LocationSettingsScreenState extends State<LocationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationBloc>().add(LoadLocationEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'إعدادات الموقع', isLeading: false),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            showCustomSnackBar(
              context: context,
              title: 'خطأ: ${state.message}',
              duration: 3,
              type: MessageType.error,
            );
          } else if (state is LocationPermissionDenied) {
            showCustomSnackBar(
              context: context,
              title: 'تم رفض إذن الموقع: ${state.message}',
              duration: 3,
              type: MessageType.error,
            );
          } else if (state is LocationPermissionPermanentlyDenied) {
            showCustomSnackBar(
              context: context,
              title: 'الإذن مرفوض نهائياً: ${state.message}',
              duration: 3,
              type: MessageType.error,
            );
          } else if (state is LocationSaved) {
            showCustomSnackBar(
              context: context,
              title: 'تم حفظ الموقع بنجاح',
              duration: 3,
              type: MessageType.success,
            );
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocationHasSavedData) {
            return _buildLocationData(state.locationData);
          } else if (state is LocationSaved) {
            return _buildLocationData({
              'latitude': state.latitude,
              'longitude': state.longitude,
              'city': state.city,
              'country': state.country,
            });
          } else if (state is LocationPermissionDenied || state is LocationPermissionPermanentlyDenied) {
            return _buildPermissionDenied(state.toString());
          } else if (state is LocationError) {
            return _buildErrorState(state.message);
          } else if (state is LocationPermissionGranted) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildInitialState();
          }
        },
      ),
    );
  }

  Widget _buildLocationData(Map<String, dynamic> locationData) {
    final latitude = locationData['latitude']?.toString() ?? 'غير متوفر';
    final longitude = locationData['longitude']?.toString() ?? 'غير متوفر';
    final city = locationData['city']?.toString() ?? 'غير متوفر';
    final country = locationData['country']?.toString() ?? 'غير متوفر';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('خط العرض: $latitude', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              Text('خط الطول: $longitude', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('الدولة: $country', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              Text('المدينة: $city', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.read<LocationBloc>().add(RefreshLocationEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConsts.basicAppColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'تحديث الموقع الحالي',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.read<LocationBloc>().add(RequestLocationPermissionEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConsts.basicAppColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'طلب موقع جديد',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('مشكلة في الإذن: $message', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<LocationBloc>().add(RequestLocationPermissionEvent());
            },
            child: const Text('طلب إذن الموقع مرة أخرى'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('حدث خطأ: $message', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<LocationBloc>().add(LoadLocationEvent());
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('جارٍ تحميل بيانات الموقع...'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<LocationBloc>().add(LoadLocationEvent());
            },
            child: const Text('تحميل الموقع'),
          ),
        ],
      ),
    );
  }
}
