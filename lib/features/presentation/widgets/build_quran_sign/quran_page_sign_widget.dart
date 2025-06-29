import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';

Widget juzPageSignWidget(String juzTitle) => Container(
      height: 50.h,
      width: 50.w,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(AppAssets.quranIconSignIcon), fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
