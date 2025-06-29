import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';

Widget quranTitleWidget(String currentSurah, Color colorCondition) => Center(
  child: Container(
      height: 48.h,
      width: 130.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.quranTitleImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Text(currentSurah,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Uthmanic',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colorCondition,
            )),
      )),
);
