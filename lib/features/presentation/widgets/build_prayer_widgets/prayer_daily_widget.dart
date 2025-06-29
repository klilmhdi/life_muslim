import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/data/models/adhan/azan_by_current_timer_model.dart';
import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';

import '../../manage/location/location_bloc.dart';

class PrayerTimingsScreen extends StatefulWidget {
  final bool isPortrait;

  const PrayerTimingsScreen({
    super.key,
    required this.isPortrait,
  });

  @override
  State<PrayerTimingsScreen> createState() => _PrayerTimingsScreenState();
}

class _PrayerTimingsScreenState extends State<PrayerTimingsScreen> {
  @override
  void initState() {
    super.initState();
    // No need to fetch prayer timings here directly. It will be triggered by LocationBloc listener in Layout.
  }

  Future<void> _fetchPrayerTimings(double latitude, double longitude) async {
    if (mounted) {
      context.read<PrayerTimingsBloc>().add(FetchPrayerTimings(latitude: latitude, longitude: longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, locationState) {
        if (locationState is LocationSaved) {
          _fetchPrayerTimings(locationState.latitude, locationState.longitude);
        }
      },
      child: BlocConsumer<PrayerTimingsBloc, PrayerTimingsState>(
        listener: (context, state) {
          // if (state is PrayerTimingsLoaded) {
          //   // يمكنك إضافة أي تفاعلات عند تحميل البيانات هنا
          // }
        },
        builder: (context, state) {
          if (state is PrayerTimingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrayerTimingsLoaded) {
            return _buildTimingsGrid(state.timings);
          }

          if (state is PrayerTimingsError) {
            return Center(
              child: Text(
                'لا يوجد اتصال بالانترنت, تحقق من الاتصال ثم اضغط على علامة التحديث',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConsts.font12size,
                  color: CupertinoColors.white,
                ),
              ),
            );
          }

          return _buildInitialView();
        },
      ),
    );
  }

  Widget _buildTimingsGrid(TodayPrayerTimingsModel timings) {
    return Row(
      children: [
        Expanded(
          child: _buildTimingItem(
            'الفجر',
            formatTimeTo12Hour(timings.fajr),
            AppAssets.fajrIcon,
            widget.isPortrait,
          ),
        ),
        // Expanded(child: _buildTimingItem('الشروق', timings.sunrise, AppAssets.sunriseIcon)),
        Expanded(
          child: _buildTimingItem(
            'الظهر',
            formatTimeTo12Hour(timings.dhuhr),
            AppAssets.dhuhrIcon,
            widget.isPortrait,
          ),
        ),
        Expanded(
          child: _buildTimingItem(
            'العصر',
            formatTimeTo12Hour(timings.asr),
            AppAssets.asrIcon,
            widget.isPortrait,
          ),
        ),
        Expanded(
          child: _buildTimingItem(
            'المغرب',
            formatTimeTo12Hour(timings.maghrib),
            AppAssets.maghribIcon,
            widget.isPortrait,
          ),
        ),
        Expanded(
          child: _buildTimingItem(
            'العشاء',
            formatTimeTo12Hour(timings.isha),
            AppAssets.ishaIcon,
            widget.isPortrait,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialView() {
    return Center(
      child: Text(
        'اضغط على علامة التحديث لكي تحصل على مواقيت الصلاة',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
          color: CupertinoColors.white,
        ),
      ),
    );
  }

  Widget _buildTimingItem(String name, String time, String image, bool isPortrait) => !isPortrait
      ? Row(
          children: [
            Image.asset(image, height: 40.h, width: 40.w),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppConsts.font12size,
                      color: CupertinoColors.white,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConsts.font10size,
                      color: CupertinoColors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      : Column(
          children: [
            Image.asset(image, height: 40.h, width: 40.w),
            SizedBox(height: 10.h),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppConsts.font12size,
                color: CupertinoColors.white,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConsts.font10size,
                color: CupertinoColors.white,
              ),
            )
          ],
        );
}
