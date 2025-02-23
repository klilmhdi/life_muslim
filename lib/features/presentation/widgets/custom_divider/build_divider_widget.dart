import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildGeneralDivider() => Column(
  children: [
    SizedBox(height: 10.h,),
    Divider(
      height: 10.h,
      thickness: 2,
    ),
    SizedBox(height: 10.h,),
  ],
);

Widget buildWideDivider() => Column(
  children: [
    SizedBox(height: 4.h,),
    Divider(
      height: 10.h,
      thickness: 1,
    ),
    SizedBox(height: 4.h,),
  ],
);