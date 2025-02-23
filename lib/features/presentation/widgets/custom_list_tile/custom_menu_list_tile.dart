import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customListTile(String icon, String title, {Widget? widget, void Function()? onTap}) =>
    ListTile(
      leading: Image.asset(icon, height: 40.h, width: 40.w,),
      title: Text(title),
      trailing: widget ?? const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
