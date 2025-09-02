import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../features/data/models/quran/surah_model.dart';
import '../consts/app_consts.dart';

/// DateTime formatted
String getFormattedDate() {
  final now = DateTime.now();
  return '${now.day}-${now.month}-${now.year}';
}

/// Times formatted
String formatTimeTo12Hour(String time) {
  if (time.isEmpty) return '';
  try {
    final timeParts = time.split(':');
    if (timeParts.length < 2) return time;

    int hour = int.parse(timeParts[0]);
    final minute = timeParts[1];

    String period = hour < 12 ? 'ص' : 'م';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  } catch (e) {
    return time;
  }
}

/// Number to arabic letters
String numberToArabicWords(int number) {
  final units = [
    "صفر", // 0 (لن يستخدم لكن للتوافق مع الفهارس)
    "الأول", // 1
    "الثاني", // 2
    "الثالث", // 3
    "الرابع", // 4
    "الخامس", // 5
    "السادس", // 6
    "السابع", // 7
    "الثامن", // 8
    "التاسع", // 9
    "العاشر" // 10
  ];

  final teens = [
    "الحادي عشر", // 11
    "الثاني عشر", // 12
    "الثالث عشر", // 13
    "الرابع عشر", // 14
    "الخامس عشر", // 15
    "السادس عشر", // 16
    "السابع عشر", // 17
    "الثامن عشر", // 18
    "التاسع عشر" // 19
  ];

  final twenties = [
    "العشرون", // 20
    "الحادي والعشرون", // 21
    "الثاني والعشرون", // 22
    "الثالث والعشرون", // 23
    "الرابع والعشرون", // 24
    "الخامس والعشرون", // 25
    "السادس والعشرون", // 26
    "السابع والعشرون", // 27
    "الثامن والعشرون", // 28
    "التاسع والعشرون" // 29
  ];

  final tens = [
    "", // 0 (غير مستخدم)
    "العاشر", // 10
    "العشرون", // 20
    "الثلاثون", // 30
    "الأربعون", // 40
    "الخمسون", // 50
    "الستون", // 60
    "السبعون", // 70
    "الثمانون", // 80
    "التسعون" // 90
  ];

  if (number >= 1 && number <= 10) {
    return units[number]; // تصحيح الفهرس هنا
  } else if (number >= 11 && number <= 19) {
    return teens[number - 11]; // تصحيح الفهرس هنا
  } else if (number >= 20 && number <= 29) {
    return twenties[number - 20]; // تصحيح الفهرس هنا
  } else if (number == 30) {
    return "الثلاثون";
  } else {
    return number.toString(); // للأرقام غير المدعومة
  }
}

/// Navigations
// -> navigate and finish
navAndFinish(context, Widget) =>
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Widget), (route) {
      return false;
    });

// -> just navigate for screen
navTo(context, Widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));

/// Animation for screens
// -> navigate with animation from down to top
class ScaleTransitionForMusic extends PageRouteBuilder {
  final Widget page;

  ScaleTransitionForMusic(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn, parent: animation, reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(
              alignment: Alignment.bottomCenter,
              scale: animation,
              child: child,
            );
          },
        );
}

navToDownToTop(context, Widget) => Navigator.push(context, ScaleTransitionForMusic(Widget));

// ->
class RTLScreenAnimation extends PageRouteBuilder {
  final Widget page;

  RTLScreenAnimation(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn, parent: animation, reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
                child: page,
              );
            });
}

navToWithRTLAnimation(context, Widget) => Navigator.push(context, RTLScreenAnimation(Widget));

// ->
class LTRScreenAnimation extends PageRouteBuilder {
  final Widget page;

  LTRScreenAnimation(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn, parent: animation, reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
                textDirection: TextDirection.rtl,
                child: page,
              );
            });
}

navToWithLTRAnimation(context, Widget) => Navigator.push(context, LTRScreenAnimation(Widget));
