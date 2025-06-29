import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../build_quran_sign/ayah_sign_widget.dart';

Widget buildQuranCardWidget(
  BuildContext context,
  String ayahText,
  String ayahNumber,
  bool isBookmarked, {
  required void Function() onTapped,
}) =>
    GestureDetector(
      onTap: onTapped,
      child: Card(
        shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        elevation: 2,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [ayahSign(context, ayahNumber)],
                    ),
                  ),
                  SizedBox(width: 4.h),
                  Expanded(
                    flex: 10,
                    child: Text(
                      ayahText,
                      style: TextStyle(
                          fontFamily: 'Uthmanic', fontSize: AppConsts.font22size, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  if (isBookmarked)
                    Icon(
                      Icons.bookmark,
                      color: Colors.deepPurple,
                      size: AppConsts.font24size,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
