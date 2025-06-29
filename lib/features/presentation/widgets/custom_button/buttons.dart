import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';

class AwesomeButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const AwesomeButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  _AwesomeButtonState createState() => _AwesomeButtonState();
}

class _AwesomeButtonState extends State<AwesomeButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 3),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isPressed ? [Colors.deepPurpleAccent, Colors.pink] : [Colors.purple, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppConsts.font18size,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Widget basicButton(
        {required VoidCallback onPressed,
        required String text,
        final double fontSize = 18,
        final double height = 60}) =>
    GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 3),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border.all(color: AppConsts.basicDarkAppColor, width: 3)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppConsts.basicDarkAppColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

Widget notificationButton() => ElevatedButton(
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.deepPurple)),
      onPressed: () {
        // NotificationService().showPrayerNotification(
        //   title: 'وقت آذان الظهر',
        //   body: 'حان الان موعد آذان الظهر, حسب التوقيت المحلي لموقعك الحالي',
        //   id: 1,
        //   duration: const Duration(seconds: 3),
        // );
      },
      child: const Text(
        'جدولة إشعار',
        style: TextStyle(color: Colors.white),
      ),
    );

Widget RowButtonsWidget(void Function() preFunction, void Function() postFunction, String tabeeh) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: AppConsts.font20size,
            highlightColor: Colors.transparent,
            onPressed: preFunction,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            tabeeh,
            style: TextStyle(
              fontSize: AppConsts.font19size,
              fontWeight: FontWeight.bold,
              fontFamily: AppConsts.uthmanic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            highlightColor: Colors.transparent,
            iconSize: AppConsts.font20size,
            onPressed: postFunction,
          ),
        ),
      ],
    );

Widget azkarButton({required String title, required void Function() onTapped}) => GestureDetector(
      onTap: onTapped,
      child: Container(
        height: 100.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          image: const DecorationImage(
            image: AssetImage(AppAssets.thirdBackgroundImage),
            fit: BoxFit.cover,
          ),
          gradient: const LinearGradient(
            colors: [
              AppConsts.skyBlueDarkColor,
              AppConsts.basicAppColor,
              AppConsts.skyBlueLightColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 20.w,
                children: [
                  Image.asset(
                    AppAssets.openBooks,
                    width: 64.w,
                    height: 64.h,
                    color: CupertinoColors.white,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppConsts.font25size,
                    ),
                  ),
                ],
              ),
              const Icon(CupertinoIcons.arrow_left, color: CupertinoColors.white)
            ],
          ),
        ),
      ),
    );
