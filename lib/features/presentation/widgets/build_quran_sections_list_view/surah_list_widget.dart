import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/ayah_sign_widget.dart';

import '../../../../core/utils/assets/assets.dart';
import '../../../../core/utils/functions/functions.dart';
import '../../manage/quran/quran_bloc.dart';
import '../../screens/quran/ayah_screen.dart';

class SurahList extends StatelessWidget {
  const SurahList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.aqsaBackgroundImage),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuranLoaded) {
            final surahs = state.quranData.data?.surahs;

            if (surahs == null || surahs.isEmpty) {
              return const Center(child: Text("No Surah data available"));
            }

            return SafeArea(
              child: ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final surah = surahs[index];
                  return Card(
                    surfaceTintColor: Colors.deepPurple,
                    elevation: 13,
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: ListTile(
                      trailing: ayahSign("${surah.number ?? 0}"),
                      title: Text(
                        surah.name ?? "Unknown", // استخدام ?? لتجنب null
                        style: TextStyle(fontFamily: 'Uthmanic', fontSize: 22.sp),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          text: surah.ayahs?.length.toString() ?? "0", // استخدام ?? لتجنب null
                          children: [
                            TextSpan(text: surah.ayahs!.length >= 10 ? " آية" : " آيات"),
                            const TextSpan(text: " | "),
                            TextSpan(text: surah.revelationType == 'Meccan' ? "مكية" : "مدنية"),
                          ],
                        ),
                      ),
                      onTap: () => navToWithLTRAnimation(context, AyahScreen(surah: surah)),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text("Failed to load Quran data"));
          }
        },
      ),
    );
  }
}
