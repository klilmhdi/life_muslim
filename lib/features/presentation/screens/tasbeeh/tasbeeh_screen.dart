import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../manage/tasbeeh/tasbeeh_cubit.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // توفير Cubit للشاشة
      create: (context) => TasbeehCubit()..loadCounter(),
      child: Scaffold(
        appBar: buildAppBar(context, title: 'التسبيح والاستغفار', isLeading: false),
        body: Center(
          child: BlocBuilder<TasbeehCubit, int>(
            builder: (context, counter) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "سُبْحَانَ اللَّه, والحمدلله, ولا اله الا الله, والله أكبرِ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Uthmanic',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$counter/00",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => context.read<TasbeehCubit>().incrementCounter(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage(AppAssets.tasbeehFrameImage),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.shade200,
                                blurRadius: 10,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "$counter",
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 35),
                    onPressed: () => context.read<TasbeehCubit>().resetCounter(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}