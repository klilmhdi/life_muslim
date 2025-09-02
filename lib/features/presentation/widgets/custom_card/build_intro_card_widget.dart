import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
// import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_prayer_widgets/prayer_daily_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/display_current_timer/display_current_timer_widget.dart';

import '../../../../core/utils/assets/assets.dart';
import '../../manage/location/location_bloc.dart';

class IntroCardWidget extends StatefulWidget {
  final Color condition;
  final bool isPortrait;

  const IntroCardWidget({
    super.key,
    required this.condition,
    required this.isPortrait,
  });

  @override
  State<IntroCardWidget> createState() => _IntroCardWidgetState();
}

class _IntroCardWidgetState extends State<IntroCardWidget> {
  late HijriCalendar format;

  @override
  void initState() {
    HijriCalendar.setLocal('ar');
    format = HijriCalendar.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {},
      builder: (context, state) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.condition,
          image: DecorationImage(
            image: AssetImage(AppAssets.thirdBackgroundImage),
            fit: widget.isPortrait ? BoxFit.fill : BoxFit.cover,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Center(
          child: widget.isPortrait
              ? _buildPortraitLayout(state, widget.isPortrait)
              : _buildLandscapeLayout(state, widget.isPortrait),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(LocationState state, bool isPortrait) => Column(
        children: [
          const Spacer(flex: 1),
          SizedBox(height: 15.h),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DelayedDisplay(
                    delay: const Duration(milliseconds: 3),
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
                              fontSize: AppConsts.font20size,
                              color: CupertinoColors.white,
                              fontFamily: AppConsts.reemKufi,
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
                                    fontSize: AppConsts.font13size,
                                    color: CupertinoColors.white,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: "${format.hDay}/",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${format.longMonthName}/",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${format.hYear}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "هـ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ])),
                              IconButton(
                                  onPressed: () => context.read<LocationBloc>().add(RefreshLocationEvent()),
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: AppConsts.font15size,
                                    color: CupertinoColors.white,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 320),
                    child: CurrentTimeScreen(
                      isPortrait: isPortrait,
                    ),
                  ),
                )
              ],
            ),
          ),
          if (state is LocationLoading) ...[const LinearProgressIndicator()] else if (state is LocationError) ...[],
          Expanded(
            flex: 2,
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 350),
              child: PrayerTimingsScreen(isPortrait: isPortrait),
            ),
          ),
        ],
      );

  Widget _buildLandscapeLayout(LocationState state, bool isPortrait) => SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 65.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: DelayedDisplay(
                    delay: const Duration(milliseconds: 3),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        spacing: 10.sp,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "السلام عليكم",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: CupertinoColors.white,
                              fontFamily: AppConsts.reemKufi,
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
                                    fontSize: AppConsts.font13size,
                                    color: CupertinoColors.white,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: "${format.hDay}/",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${format.longMonthName}/",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${format.hYear}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "هـ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppConsts.font13size,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ])),
                              IconButton(
                                  onPressed: () => context.read<LocationBloc>().add(RefreshLocationEvent()),
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: AppConsts.font15size,
                                    color: CupertinoColors.white,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DelayedDisplay(
                    delay: const Duration(milliseconds: 320),
                    child: CurrentTimeScreen(
                      isPortrait: isPortrait,
                    ),
                  ),
                )
              ],
            ),
            if (state is LocationLoading) ...[const LinearProgressIndicator()] else if (state is LocationError) ...[],
            DelayedDisplay(
              delay: const Duration(milliseconds: 350),
              child: PrayerTimingsScreen(isPortrait: isPortrait),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      );
}
