import 'package:flutter/cupertino.dart';
import '../../../../core/utils/consts/app_consts.dart';
import '../../../data/models/quran/surah_model.dart';

List<InlineSpan> buildQuranContentWidget(Color colorCondition, SurahModel surah) {
  List<InlineSpan> spans = [];
  int? lastPage;

  const wordsToHighlight = AppConsts.redWords;
  var fontValue = AppConsts.font22size;

  for (var ayah in surah.ayahs!) {
    String remainingText = ayah.text!;
    int currentIndex = 0;

    if (lastPage != null && ayah.page != lastPage) {
      // spans.add(WidgetSpan(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 8.0),
      //       child: Container(
      //         width: double.infinity,
      //         height: 50,
      //         decoration: BoxDecoration(border: Border.all(color: colorCondition)),
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Text(
      //                 'رقم الحزب: ${ayah.hizbQuarter}',
      //                 style: TextStyle(
      //                     fontSize: AppConsts.font16size,
      //                     color: colorCondition,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //               Container(
      //                 height: 50,
      //                 width: 50,
      //                 decoration: BoxDecoration(border: Border.all(color: colorCondition)),
      //                 child: ayahSign(ayah.page.toString()),
      //               ),
      //               Text(
      //                 ' رقم الجزء: ${ayah.juz}',
      //                 style: TextStyle(
      //                     fontSize: AppConsts.font16size,
      //                     color: colorCondition,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ));
    }

    while (currentIndex < remainingText.length) {
      bool wordFound = false;

      for (var word in wordsToHighlight) {
        if (remainingText.startsWith(word, currentIndex)) {
          spans.add(
            TextSpan(
              text: remainingText.substring(0, currentIndex),
              style: TextStyle(color: colorCondition, fontSize: fontValue),
            ),
          );

          spans.add(
            TextSpan(
              text: word,
              style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: fontValue),
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
        style: TextStyle(color: colorCondition, fontSize: fontValue),
      ),
    );

    spans.add(
      TextSpan(
        text: "(${ayah.numberInSurah})",
        style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: fontValue),
      ),
    );

    spans.add(const TextSpan(text: " "));
    lastPage = ayah.page;
  }

  // spans.add(TextSpan(
  //   text: "\n${AppConsts.endSurah}",
  //   style: TextStyle(
  //     fontSize: fontValue,
  //     color: colorCondition,
  //     fontWeight: FontWeight.bold,
  //   ),
  // ));

  return spans;
}
