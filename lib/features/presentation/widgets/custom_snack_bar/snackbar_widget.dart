import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';

void showCustomSnackBar({required BuildContext context,
    required String title,
    required int duration,
    required MessageType type}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case MessageType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle_outline;
      break;
    case MessageType.error:
      backgroundColor = Colors.red;
      icon = Icons.cancel;
      break;
    case MessageType.info:
      backgroundColor = Colors.deepPurple;
      icon = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
      margin: EdgeInsets.all(15.w),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30.w,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
