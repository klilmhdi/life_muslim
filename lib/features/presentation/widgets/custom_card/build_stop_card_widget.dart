import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';

Widget buildStopCardWidget() => SizedBox(
      height: 150.h,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          shadowColor: Colors.deepPurpleAccent,
          surfaceTintColor: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.book,
                            size: 18.sp,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            "لقد توقفت هنا",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "إستكمال القراءة",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8.sp),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.deepPurple,
                            size: 10.sp,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "سورة الفاتحة",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                  fontFamily: 'Uthmanic'),
                            ),
                            Text(
                              "الآية رقم: (3)",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                fontFamily: 'Uthmanic',
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        child: Image.asset(
                      AppAssets.stopSurahImage,
                      height: 80.h,
                      width: 80.w,
                    ))
                  ],
                ),
              ],
            ),
          ),
          // borderOnForeground: ,
        ),
      ),
    );
