import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

class CurrentTimeScreen extends StatefulWidget {
  final bool isPortrait;

  const CurrentTimeScreen({
    super.key,
    required this.isPortrait,
  });

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
          fontSize: widget.isPortrait ? AppConsts.font30size : AppConsts.font21size,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.white,
        ),
      );
}
