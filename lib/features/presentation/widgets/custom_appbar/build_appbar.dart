import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';

PreferredSizeWidget buildAppBar(
  context, {
  required String title,
  required bool isLeading,
  bool isBottom = false,
  Color? color,
  String? font,
  Widget? extraWidget,
}) =>
    AppBar(
      backgroundColor: CupertinoColors.transparent,
      leading: isLeading
          ? Builder(builder: (context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(
                    Icons.menu,
                    color: CupertinoColors.white,
                  ));
            })
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: color, fontFamily: font ?? 'Tajawal'),
      ),
      actions: [
        BlocBuilder<AppCubit, AppState>(
          buildWhen: (previous, current) => previous.themeCurrentIndex != current.themeCurrentIndex,
          builder: (context, state) {
            AppCubit appCubit = BlocProvider.of(context, listen: false);
            // return Switch.adaptive(
            //     activeColor: Colors.deepPurple,
            //     value: state.themeCurrentIndex == 0,
            //     onChanged: (value) {
            //       if (state.themeCurrentIndex == 0) {
            //         appCubit.setThemeIndex(themeIndex: 1);
            //       } else {
            //         appCubit.setThemeIndex(themeIndex: 0);
            //       }
            //     });
            return InkWell(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (state.themeCurrentIndex == 0) {
                    appCubit.setThemeIndex(themeIndex: 1);
                  } else {
                    appCubit.setThemeIndex(themeIndex: 0);
                  }
                },
                child: Image.asset(
                    state.themeCurrentIndex == 0 ? AppAssets.lightIcon : AppAssets.darkIcon,
                    height: 35.h,
                    width: 35.w));
          },
        ),
        SizedBox(width: 10.w),
        extraWidget ?? const SizedBox(),
        SizedBox(width: 10.w)
      ],
      bottom: isBottom == true
          ? const TabBar(
              dividerColor: Colors.transparent,
              tabs: [Tab(text: 'سور القرآن الكريم'), Tab(text: 'الأجزاء')])
          : null,
    );
