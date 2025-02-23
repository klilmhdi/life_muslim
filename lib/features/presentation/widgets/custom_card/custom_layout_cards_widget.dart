import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';

Widget customLayoutCardWidget(BuildContext context, String title, Widget screen) => GestureDetector(
      onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
        navTo(context, screen);
      }),
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title)
          ],
        ),
      ),
    );
