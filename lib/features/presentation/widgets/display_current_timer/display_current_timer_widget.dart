import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CurrentTimeScreen extends StatefulWidget {
  const CurrentTimeScreen({super.key});

  @override
  _CurrentTimeScreenState createState() => _CurrentTimeScreenState();
}

class _CurrentTimeScreenState extends State<CurrentTimeScreen> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        DateTime now = DateTime.now();
        _currentTime = DateFormat('hh:mm a').format(now);
      });
    }

    Future.delayed(const Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) => Text(
    _currentTime,
    style: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: CupertinoColors.white,
    ),
  );
}
