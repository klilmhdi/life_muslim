import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/manage/quran/quran_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/quran/ayah_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(
          context,
          title: "القرآن الكريم",
          isLeading: false,
          font: 'Uthmanic',
        ),
        body: const SurahList(),
      ),
    );
  }
}

class SurahList extends StatelessWidget {
  const SurahList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state is QuranLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuranLoaded) {
          final surahs = state.quranData.data?.surahs;

          if (surahs == null || surahs.isEmpty) {
            return const Center(child: Text("No Surah data available"));
          }

          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.aqsaBackgroundImage),
                    fit: BoxFit.cover,
                    opacity: 0.3)),
            child: SafeArea(
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
                      // title: Text(surah.englishName ?? "Unknown", style: const TextStyle(fontFamily: 'Uthmanic'),),
                      trailing: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AppAssets.ayahNumberSignIcon, height: 35.h, width: 35.w),
                          Text(
                            "${surah.number}",
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      title: Text(
                        surah.name ?? "Unknown",
                        style: TextStyle(fontFamily: 'Uthmanic', fontSize: 22.sp),
                      ),
                      subtitle:
                          Text.rich(TextSpan(text: surah.ayahs?.length.toString() ?? "0", children: [
                        TextSpan(text: surah.ayahs!.length >= 10 ? " آية" : " آيات"),
                        const TextSpan(text: " | "),
                        TextSpan(text: surah.revelationType == 'Meccan' ? "مكية" : "مدنية")
                      ])),
                      onTap: () => navToWithLTRAnimation(context, AyahScreen(surah: surah)),
                      // onTap: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AyahScreen(surah: surah, startAyahIndex: 0),
                      //   ),
                      // ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(child: Text("Failed to load Quran data"));
        }
      },
    );
  }
}
