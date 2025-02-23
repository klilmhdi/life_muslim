import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';

PreferredSizeWidget buildAppBar(context,
        {required String title, Color? color, required bool isLeading, String? font, Widget? extraWidget}) =>
    AppBar(
      backgroundColor: CupertinoColors.transparent,
      leading: isLeading
          ? Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(
                    Icons.menu,
                    color: CupertinoColors.white,
                  ));
            }
          )
          : IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: color, fontFamily: font ?? 'Tajawal'),
      ),
      actions: [
        BlocBuilder<AppCubit, AppState>(
          buildWhen: (previous, current) => previous.themeCurrentIndex != current.themeCurrentIndex,
          builder: (context, state) {
            AppCubit appCubit = BlocProvider.of(context, listen: false);
            return Switch.adaptive(
                activeColor: Colors.deepPurple,
                value: state.themeCurrentIndex == 0,
                onChanged: (value) {
                  if (state.themeCurrentIndex == 0) {
                    appCubit.setThemeIndex(themeIndex: 1);
                  } else {
                    appCubit.setThemeIndex(themeIndex: 0);
                  }
                });
          },
        ),
        extraWidget ?? const SizedBox()
      ],
    );
