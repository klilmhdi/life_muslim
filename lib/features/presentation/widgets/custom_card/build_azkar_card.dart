import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';

import '../../../../core/utils/consts/app_consts.dart';

Widget buildAzkarCardWidget({
  required String azkarTitle,
  required String azkarNumber,
}) =>
    Padding(
      padding: EdgeInsets.all(3.sp),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(AppAssets.thirdBackgroundImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.sp),
          gradient: LinearGradient(
            colors: [
              AppConsts.skyBlueDarkColor.withValues(alpha: 0.5),
              AppConsts.skyBlueLightColor.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.openBooks,
              width: 64.w,
              height: 64.h,
              theme: SvgTheme(currentColor: AppConsts.basicDarkAppColor),
            ),
            SizedBox(height: 10.h),
            Text(
              azkarTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: AppConsts.font12size, fontWeight: FontWeight.bold, color: AppConsts.basicDarkAppColor),
            ),
            SizedBox(height: 5.h),
            Text(
              azkarNumber,
              style: TextStyle(fontSize: AppConsts.font14size, color: AppConsts.basicDarkAppColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

Widget buildNameOfAllahCardWidget({
  required String nameId,
  required String nameTitle,
}) =>
    Padding(
      padding: EdgeInsets.all(3.sp),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(AppAssets.thirdBackgroundImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.sp),
          gradient: LinearGradient(
            colors: [
              AppConsts.skyBlueDarkColor.withValues(alpha: 0.5),
              AppConsts.skyBlueLightColor.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.nameOfAllahIcon,
              width: 64.w,
              height: 64.h,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 2.w,
              children: [
                Text(
                  "$nameId.",
                  style: TextStyle(
                    fontSize: AppConsts.font16size,
                    color: AppConsts.basicDarkAppColor,
                  ),
                ),
                Text(
                  nameTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: AppConsts.font16size, fontWeight: FontWeight.bold, color: AppConsts.basicDarkAppColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
