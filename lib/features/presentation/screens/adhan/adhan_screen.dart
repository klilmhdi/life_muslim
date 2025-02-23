import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/prayer_timings_bloc.dart';

class PrayerTimingsScreen extends StatefulWidget {
  const PrayerTimingsScreen({super.key});

  @override
  State<PrayerTimingsScreen> createState() => _PrayerTimingsScreenState();
}

class _PrayerTimingsScreenState extends State<PrayerTimingsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPrayerTimings();
  }

  Future<void> _fetchPrayerTimings() async {
    final location = await SharedPrefController.getLocation();
    final latitude = location['latitude'];
    final longitude = location['longitude'];

    if (latitude == 0.0 || longitude == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not found. Please enable location services.')),
      );
      return;
    }

    context.read<PrayerTimingsBloc>().add(
          FetchPrayerTimings(
            latitude: latitude!,
            longitude: longitude!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsBloc, PrayerTimingsState>(
        builder: (context, state) => _buildBody(state));
  }

  Widget _buildBody(PrayerTimingsState state) {
    if (state is PrayerTimingsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is PrayerTimingsLoaded) {
      final timings = state.timings;
      return Row(
        children: [
          Expanded(child: _buildTimingItem('الفجر', timings.fajr, AppAssets.fajrIcon)),
          Expanded(child: _buildTimingItem('الشروق', timings.sunrise, AppAssets.sunriseIcon)),
          Expanded(child: _buildTimingItem('الظهر', timings.dhuhr, AppAssets.dhuhrIcon)),
          Expanded(child: _buildTimingItem('العصر', timings.asr, AppAssets.asrIcon)),
          Expanded(child: _buildTimingItem('المغرب', timings.maghrib, AppAssets.maghribIcon)),
          Expanded(child: _buildTimingItem('العشاء', timings.isha, AppAssets.ishaIcon)),
        ],
      );
    } else if (state is PrayerTimingsError) {
      return Center(child: Text(state.message));
    }
    return const Center(child: Text('Press refresh to get prayer timings.'));
  }

  Widget _buildTimingItem(String name, String time, String image) => Column(children: [
        Image.asset(image, height: 40.h, width: 40.w),
        SizedBox(height: 10.h),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: CupertinoColors.white,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
            color: CupertinoColors.white,
          ),
        )
      ]);
}
