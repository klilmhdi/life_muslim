import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../../manage/change_ayah_display/change_ayah_display_cubit.dart';

class ChangeAyahDisplayScreen extends StatefulWidget {
  const ChangeAyahDisplayScreen({super.key});

  @override
  State<ChangeAyahDisplayScreen> createState() => _ChangeAyahDisplayScreenState();
}

class _ChangeAyahDisplayScreenState extends State<ChangeAyahDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeAyahDisplayCubit, ChangeAyahDisplayState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(context, title: "تغيير طريقة عرض الآيات", isLeading: false),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  title: RadioListTile<AyahDisplayMode>(
                    title: const Text('قائمة آيات', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: AyahDisplayMode.scroll,
                    groupValue: state.displayMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<ChangeAyahDisplayCubit>().updateDisplayMode(value);
                      }
                    },
                  ),
                  children: [Image.asset('assets/images/list.png')],
                ),
                ExpansionTile(
                  title: RadioListTile<AyahDisplayMode>(
                    title: const Text('صفحة (المصحف)', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: AyahDisplayMode.page,
                    groupValue: state.displayMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<ChangeAyahDisplayCubit>().updateDisplayMode(value);
                      }
                    },
                  ),
                  children: [Image.asset('assets/images/page.jpg')],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
