import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

Widget ayahSign(context, String ayahNumber) => Stack(
  alignment: Alignment.center,
  children: [
    Image.asset(AppAssets.ayahNumberSignIcon, height: 40.h, width: 40.w),
    Text(
      ayahNumber,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: MediaQuery.orientationOf(context) == Orientation.portrait ? AppConsts.font12size : AppConsts.font8size,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ],
);