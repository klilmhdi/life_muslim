import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // مهم
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';

Widget juzPageSignWidget(String juzTitle) => SizedBox(
      height: 50.h,
      width: 50.w,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SvgPicture.asset(AppAssets.quranIconSignIcon, fit: BoxFit.cover, height: 50.h, width: 50.w),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "رقم \nالصفحة",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CupertinoColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: AppConsts.font7size,
                  ),
                ),
                Text(
                  juzTitle,
                  style: TextStyle(
                    color: CupertinoColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: AppConsts.font11size,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
