import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

class EmptyWidgets {
  const EmptyWidgets._();

  static Widget bookmarkEmptyWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.sp,
          children: [
            Image.asset(AppAssets.bookmarkIcon, height: 80.h, width: 80.w),
            Center(
              child: Text(
                "لم يتم حفظ أي آيات في العلامات المرجعية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppConsts.font22size,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  static Widget favouriteAyahEmptyWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.favIcon, height: 50.h, width: 50.w),
          Center(
            child: Text(
              "لم يتم حفظ أي آيات في العلامات المرجعية",
              style: TextStyle(
                fontSize: AppConsts.font22size,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
}
