import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

Widget customListTile(String icon, String title, {required bool isSoon, void Function()? onTap}) => ListTile(
      // leading: Image.asset(
      //   icon,
      //   height: 40.h,
      //   width: 40.w,
      // ),
      leading: SvgPicture.asset(
        icon,
        height: 40.h,
        width: 40.w,
      ),
      title: Text(title),
      trailing: isSoon == true ? soonCardWidget() : const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );

Widget soonCardWidget() => Container(
      width: 45.w,
      height: 45.h,
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          radius: 1.4,
          colors: [AppConsts.basicAppColor, AppConsts.basicDarkAppColor],
        ),
        borderRadius: BorderRadius.circular(AppConsts.font8size),
      ),
      child: const Center(
        child: Text(
          "قريباً",
          style: TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
