import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../../../core/app_cubit/app/app_cubit.dart';
import '../../../../core/utils/assets/assets.dart';

class AyahJuzPage extends StatelessWidget {
  final List<SurahModel> surahs;
  final int partNumber;

  const AyahJuzPage({super.key, required this.surahs, required this.partNumber});

  @override
  Widget build(BuildContext context) {
    final List<AyahWithSurah> partAyahs = [];
    for (var surah in surahs) {
      for (var ayah in surah.ayahs!) {
        if (ayah.juz == partNumber) {
          partAyahs.add(AyahWithSurah(surah: surah, ayah: ayah));
        }
      }
    }

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(context, title: "الجزء $partNumber", isLeading: false),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.aqsaBackgroundImage),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Uthmanic',
                        ),
                        children: _buildAyahTextWithPageSeparation(
                            partAyahs, state.themeCurrentIndex == 0 ? Colors.black : Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 3. تعديل دالة بناء النص لإضافة عنوان السورة مرة واحدة عند الانتقال من سورة لأخرى
  List<InlineSpan> _buildAyahTextWithPageSeparation(List<AyahWithSurah> ayahWithSurahList,
      Color colorCondition) {
    List<InlineSpan> spans = [];
    SurahModel? lastSurah;
    int? lastPage;

    final wordsToHighlight = [
      "ٱللَّهِ",
      "لِلَّهِ",
      "ٱللَّهُ",
      "ٱللَّهَ",
      "الٓمٓ",
      "الٓمٓصٓ",
      "الٓرۚ",
      "الٓمٓرۚ",
      "كٓهيعٓصٓ",
      "طه",
      "طسٓمٓ",
      "طسٓۚ",
      "يسٓ",
      "صٓۚ",
      "حمٓ",
      "حم",
      "عٓسٓقٓ",
      "قٓۚ",
      "نٓۚ"
    ];

    for (var ayahWithSurah in ayahWithSurahList) {
      final currentSurah = ayahWithSurah.surah;
      final ayah = ayahWithSurah.ayah;

      if (lastPage != null && ayah.page != lastPage) {
        spans.add(TextSpan(
            text: "\nالحزب: ${ayah.hizbQuarter}  ",
            style: TextStyle(
              fontSize: 10.sp,
              color: colorCondition,
              fontWeight: FontWeight.bold,
            ),
            children: [
              // TextSpan(
              //   text: " ───────── ",
              //   style: TextStyle(
              //     fontSize: 14.sp,
              //     color: colorCondition,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // WidgetSpan(
              //   child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              //     child: Text("${ayah.page}"),),
              //   style: TextStyle(
              //     fontSize: 14.sp,
              //     color: colorCondition,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // TextSpan(
              //   text: " ───────── ",
              //   style: TextStyle(
              //     fontSize: 14.sp,
              //     color: colorCondition,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              TextSpan(
                text: " ─────────── ${ayah.page} ─────────── ",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorCondition,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: " الجزء: ${ayah.juz}\n",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colorCondition,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]));
      }

      if (lastSurah == null || lastSurah.number != currentSurah.number) {
        spans.add(TextSpan(
          text: "* ${currentSurah.name} * \n",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorCondition,
          ),
        ));
      }

      String remainingText = ayah.text!;
      int currentIndex = 0;

      while (currentIndex < remainingText.length) {
        bool wordFound = false;
        for (var word in wordsToHighlight) {
          if (remainingText.startsWith(word, currentIndex)) {
            spans.add(TextSpan(
              text: remainingText.substring(0, currentIndex),
              style: TextStyle(color: colorCondition),
            ));
            spans.add(TextSpan(
              text: word,
              style: const TextStyle(color: Colors.red),
            ));
            remainingText = remainingText.substring(currentIndex + word.length);
            currentIndex = 0;
            wordFound = true;
            break;
          }
        }
        if (!wordFound) {
          currentIndex++;
        }
      }
      spans.add(TextSpan(text: remainingText, style: TextStyle(color: colorCondition)));
      spans.add(
          TextSpan(text: " (${ayah.numberInSurah}) ", style: TextStyle(color: colorCondition)));
      spans.add(const TextSpan(text: " "));

      lastPage = ayah.page;

      lastSurah = currentSurah;
    }

    return spans;
  }
}

class AyahWithSurah {
  final SurahModel surah;
  final AyahsModel ayah;

  AyahWithSurah({required this.surah, required this.ayah});
}
