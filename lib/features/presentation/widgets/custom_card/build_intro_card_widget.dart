import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/prayer_timings_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/adhan/adhan_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/display_current_timer/display_current_timer_widget.dart';

import '../../../../core/utils/assets/assets.dart';

class IntroCardWidget extends StatefulWidget {
  const IntroCardWidget({super.key});

  @override
  State<IntroCardWidget> createState() => _IntroCardWidgetState();
}

class _IntroCardWidgetState extends State<IntroCardWidget> {
  late HijriCalendar format;

  @override
  void initState() {
    HijriCalendar.setLocal('ar');
    format = HijriCalendar.now();
    _fetchPrayerTimings();
    super.initState();
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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: state.themeCurrentIndex == 0
                ? Colors.deepPurpleAccent.shade700
                : Colors.deepPurpleAccent.shade200,
            image: const DecorationImage(
              image: AssetImage(AppAssets.thirdBackgroundImage),
              fit: BoxFit.fill,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                SizedBox(height: 15.h),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "السلام عليكم",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                  color: CupertinoColors.white,
                                  fontFamily: 'Reem_Kufi',
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text.rich(TextSpan(
                                      text: "${format.dayWeName}:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp,
                                        color: CupertinoColors.white,
                                      ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: "${format.hDay}/",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp,
                                            color: CupertinoColors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${format.longMonthName}/",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                            color: CupertinoColors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${format.hYear}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp,
                                            color: CupertinoColors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "هـ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp,
                                            color: CupertinoColors.white,
                                          ),
                                        ),
                                      ])),
                                  IconButton(
                                      onPressed: () async => _fetchPrayerTimings(),
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        size: 15,
                                        color: CupertinoColors.white,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(flex: 2, child: CurrentTimeScreen())
                    ],
                  ),
                ),
                const Expanded(flex: 2, child: PrayerTimingsScreen()),
              ],
            ),
          ),
        );
      },
    );
  }
}
