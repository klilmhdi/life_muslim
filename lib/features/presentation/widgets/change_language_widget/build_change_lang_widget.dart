import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_cubit/app/app_cubit.dart';
import '../../../../generated/l10n.dart';

Widget buildChangeLangWidget() => BlocBuilder<AppCubit, AppState>(
  buildWhen: (previous, current) => previous.languageCode != current.languageCode,
  builder: (context, state) {
    AppCubit appCubit = BlocProvider.of(context, listen: false);
    return Column(
      children: [
        RadioListTile<String>(
          activeColor: Colors.deepPurple,
          onChanged: (String? value) {
            appCubit.setLanguage(languageCode: 'en');
          },
          value: state.languageCode,
          groupValue: "en",
          // title: Text(S.of(context).engl),
        ),
        RadioListTile<String>(
          activeColor: Colors.deepPurple,
          // title: Text(S.of(context).arab),
          value: state.languageCode,
          groupValue: "ar",
          onChanged: (String? value) {
            appCubit.setLanguage(languageCode: 'ar');
          },
        ),
      ],
    );
  },
);
