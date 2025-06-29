import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';

Widget quranQuarterWidget(String quarterTitle) => Container(
      height: 40.h,
      width: 40.w,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(AppAssets.hizbIconIcon), fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "الحزب",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CupertinoColors.black,
                fontWeight: FontWeight.bold,
                fontSize: AppConsts.font7size,
              ),
            ),
            Text(
              quarterTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                fontSize: AppConsts.font10size,
              ),
            ),
          ],
        ),
      ),
    );
