import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_cubit/app/app_cubit.dart';

Widget buildChangeThemeWidget() => BlocBuilder<AppCubit, AppState>(
  buildWhen: (previous, current) =>
  previous.themeCurrentIndex != current.themeCurrentIndex,
  builder: (context, state) {
    AppCubit appCubit = BlocProvider.of(context, listen: false);
    return Switch.adaptive(
        activeColor: Colors.deepPurple, // change it to app color basic
        //=========> 0 Light
        value: state.themeCurrentIndex == 0,
        onChanged: (value) {
          if (state.themeCurrentIndex == 0) {
            appCubit.setThemeIndex(themeIndex: 1);
          } else {
            appCubit.setThemeIndex(themeIndex: 0);
          }
        });
  },
);
