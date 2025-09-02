import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';

Widget quranQuarterWidget(String quarterTitle) => SizedBox(
      height: 40.h,
      width: 40.w,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SvgPicture.asset(
            AppAssets.hizbIconIcon,
            fit: BoxFit.cover,
            height: 40.h,
            width: 40.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الحزب",
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
                  fontSize: AppConsts.font8size,
                ),
              ),
            ],
          ),
        ],
      ),
    );
