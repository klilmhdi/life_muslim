import 'package:flutter/cupertino.dart';

import '../../../../core/utils/consts/app_consts.dart';
import '../../../data/models/quran/quran_ayah_model.dart';
import '../../../data/models/quran/surah_model.dart';
import 'build_quran_title_widget.dart';

List<InlineSpan> buildJuzWidget(
  BuildContext context,
  List<AyahWithSurah> ayahWithSurahList,
  Color colorCondition,
) {
  List<InlineSpan> spans = [];
  SurahModel? lastSurah;

  const wordsToHighlight = AppConsts.redWords;

  for (var ayahWithSurah in ayahWithSurahList) {
    final currentSurah = ayahWithSurah.surah;
    final ayah = ayahWithSurah.ayah;

    if (lastSurah == null || lastSurah.number != currentSurah.number) {
      spans.add(const TextSpan(text: "\n"));
      spans.add(MediaQuery.orientationOf(context) == Orientation.portrait
          ? WidgetSpan(child: quranTitleWidget(currentSurah.name.toString(), colorCondition))
          : TextSpan(text: currentSurah.name.toString(), style: TextStyle(color: colorCondition, fontSize: AppConsts.font18size, fontWeight: FontWeight.bold)));

      spans.add(const TextSpan(text: "\n"));
      if (ayah.numberInSurah == 1) {
        spans.add(WidgetSpan(
          child: Center(
            child: Text(
                (currentSurah.name == "سُورَةُ التَّوۡبَةِ" || currentSurah.name == "سُورَةُ ٱلْفَاتِحَةِ")
                    ? ''
                    : AppConsts.bismillah,
                style: TextStyle(
                  fontSize: AppConsts.font18size,
                  fontWeight: FontWeight.bold,
                  color: colorCondition,
                  fontFamily: 'Uthmanic',
                )),
          ),
        ));
      }
    }

    String remainingText = ayah.text!;
    int currentIndex = 0;

    while (currentIndex < remainingText.length) {
      bool wordFound = false;
      for (var word in wordsToHighlight) {
        if (remainingText.startsWith(word, currentIndex)) {
          spans.add(
            TextSpan(
              text: remainingText.substring(0, currentIndex),
              style: TextStyle(color: colorCondition, fontSize: AppConsts.font19size),
            ),
          );
          spans.add(
            TextSpan(
              text: word,
              style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: AppConsts.font19size),
            ),
          );
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

    spans.add(
      TextSpan(
        text: remainingText,
        style: TextStyle(color: colorCondition, fontSize: AppConsts.font19size),
      ),
    );
    spans.add(
      TextSpan(
        text: "(${ayah.numberInSurah})",
        style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: AppConsts.font19size),
      ),
    );
    spans.add(const TextSpan(text: " "));
    if (ayah.numberInSurah == currentSurah.ayahs!.last.numberInSurah) {
      spans.add(
        WidgetSpan(
          child: Center(
            child: Text(
              AppConsts.endSurah,
              style: TextStyle(
                fontSize: AppConsts.font18size,
                fontWeight: FontWeight.bold,
                fontFamily: 'Uthmanic',
                color: colorCondition,
              ),
            ),
          ),
        ),
      );
    }

    lastSurah = currentSurah;
  }

  return spans;
}
