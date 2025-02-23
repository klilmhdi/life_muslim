import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/screens/adhan/adhan_screen.dart';

Widget ayahSign(String ayahNumber) => Stack(
  alignment: Alignment.center,
  children: [
    Image.asset(AppAssets.ayahNumberSignIcon, height: 30.h, width: 30.w),
    Text(
      ayahNumber,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ],
);