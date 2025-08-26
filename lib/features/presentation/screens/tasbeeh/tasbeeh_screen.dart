import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_button/buttons.dart';

import '../../manage/tasbeeh/tasbeeh_cubit.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasbeehCubit()..loadCounter(),
      child: Scaffold(
        appBar: buildAppBar(context, title: 'التسبيح والاستغفار', isLeading: false),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.tasbeehBackgroundImage), fit: BoxFit.cover, opacity: 0.5)),
          child: SafeArea(
            child: BlocBuilder<TasbeehCubit, TasbeehState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: rowButtonsWidget(() {
                            final currentIndex = state.tasbeehList.indexOf(state.selectedTasbeeh);
                            if (currentIndex > 0) {
                              final prevItem = state.tasbeehList[currentIndex - 1];
                              context.read<TasbeehCubit>().selectTasbeeh(prevItem);
                            }
                          }, () {
                            final currentIndex = state.tasbeehList.indexOf(state.selectedTasbeeh);
                            if (currentIndex < state.tasbeehList.length - 1) {
                              final nextItem = state.tasbeehList[currentIndex + 1];
                              context.read<TasbeehCubit>().selectTasbeeh(nextItem);
                            }
                          }, state.selectedTasbeeh),
                        ),
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: () => context.read<TasbeehCubit>().incrementCounter(),
                            child: Container(
                              width: 350.w,
                              height: 350.h,
                              decoration:
                                  BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.transparent)),
                              child: AnimatedFlipCounter(
                                  duration: const Duration(milliseconds: 500),
                                  value: state.counter,
                                  textStyle: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.refresh, size: 28.sp),
                            onPressed: () => context.read<TasbeehCubit>().resetCounter()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
