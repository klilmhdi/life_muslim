import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget buildSmoothPageIndicator(
  BuildContext context, {
  required PageController controller,
  required int count,
  required bool isBookmarked,
  required Function(int) onClicked,
}) =>
    SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ScrollingDotsEffect(
        dotHeight: MediaQuery.orientationOf(context) == Orientation.portrait ? 8.sp : 5.sp,
        dotWidth: MediaQuery.orientationOf(context) == Orientation.portrait ? 8.sp : 5.sp,
        maxVisibleDots: 7,
        activeDotColor: isBookmarked ? AppConsts.quranIndicatorColor : AppConsts.basicAppColor,
      ),
      onDotClicked: (index) {
        onClicked(index);
        controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 3),
          curve: Curves.easeInOut,
        );
      },
    );
