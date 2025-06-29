import 'package:flutter/material.dart';

Widget buildBackgroundWidget({required String background, Color? color}) => Row(
      children: [
        Expanded(
          child: Image.asset(
            background,
            fit: BoxFit.cover,
            height: double.infinity,
            color: color,
          ),
        ),
        Expanded(
          child: Image.asset(
            background,
            fit: BoxFit.cover,
            height: double.infinity,
            color: color,
          ),
        ),
      ],
    );
