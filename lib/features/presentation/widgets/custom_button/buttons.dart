import 'package:flutter/material.dart';

import '../../../../core/utils/notification/notification_service.dart';

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
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isPressed
                ? [Colors.deepPurpleAccent, Colors.pink]
                : [Colors.purple, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Widget notificationButton() => ElevatedButton(
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.deepPurple)),
      onPressed: () {
        NotificationService().showPrayerNotification(
          title: 'وقت آذان الظهر',
          body: 'حان الان موعد آذان الظهر, حسب التوقيت المحلي لموقعك الحالي',
          id: 1,
          duration: const Duration(seconds: 3),
        );
      },
      child: const Text(
        'جدولة إشعار',
        style: TextStyle(color: Colors.white),
      ),
    );
