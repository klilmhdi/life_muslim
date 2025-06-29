import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';

Widget azkarListTile(
  BuildContext context, {
  required String title,
  required isTrailing,
  String? subtitle,
  String? count,
  void Function()? onTapped,
}) =>
    Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage(AppAssets.thirdBackgroundImage),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            AppConsts.skyBlueDarkColor.withValues(alpha: 0.5),
            AppConsts.skyBlueLightColor.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: ListTile(
        onTap: onTapped,
        title: Text(
          title,
          style: TextStyle(
            fontSize: subtitle == null || subtitle == ""
                ? MediaQuery.orientationOf(context) == Orientation.portrait
                    ? AppConsts.font16size
                    : AppConsts.font15size
                : AppConsts.font14size,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle == null || subtitle == ""
            ? const SizedBox()
            : Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppConsts.font10size,
                  fontWeight: FontWeight.w800,
                ),
              ),
        trailing: isTrailing == true
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.repeatIcon,
                    color: AppConsts.skyBlueDarkColor,
                    height: 40.h,
                    width: 40.w,
                  ),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: AppConsts.font14size,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            : const SizedBox(),
      ),
    );
