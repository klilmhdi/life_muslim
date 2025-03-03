import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

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
                  image: AssetImage(AppAssets.tasbeehBackgroundImage),
                  fit: BoxFit.cover,
                  opacity: 0.5)),
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              hint: const Text('اختر الذكر', style: TextStyle(fontSize: 16)),
                              iconSize: 30,
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: state.selectedTasbeeh,
                              iconEnabledColor: Colors.red.shade900,
                              icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                              items: state.tasbeehList
                                  .map((String value) => DropdownMenuItem<String>(
                                        enabled: true,
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Uthmanic',
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) => context.read<TasbeehCubit>().selectTasbeeh(value!),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            state.selectedTasbeeh,
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Uthmanic',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: () => context.read<TasbeehCubit>().incrementCounter(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 350.w,
                                  height: 350.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // image: const DecorationImage(
                                    //   image: AssetImage(AppAssets.tasbeehFrameImage),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    border: Border.all(color: Colors.deepPurple),
                                    boxShadow: [
                                      // BoxShadow(
                                      //   color: Colors.deepPurpleAccent.shade200,
                                      //   blurRadius: 10,
                                      //   spreadRadius: 3,
                                      // ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${state.counter}",
                                  // "999999999",
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
