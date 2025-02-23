import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';

class QuranPageWidget extends StatelessWidget {
  final SurahModel surah;

  const QuranPageWidget({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
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
                    color: state.themeCurrentIndex == 0 ? Colors.black : Colors.white,
                    fontFamily: 'Uthmanic',
                  ),
                  text:
                      (surah.name == "سُورَةُ التَّوۡبَةِ" || surah.name == "سُورَةُ ٱلْفَاتِحَةِ")
                          ? null
                          : 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ\n',
                  children: _buildAyahTextWithPageSeparation(
                      state.themeCurrentIndex == 0 ? Colors.black : Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<InlineSpan> _buildAyahTextWithPageSeparation(colorCondition) {
    List<InlineSpan> spans = [];
    int? lastPage;

    // List of words to highlight in red
    final wordsToHighlight = ["ٱللَّهِ", "لِلَّهِ", "ٱللَّهُ", "ٱللَّهَ"];

    for (var ayah in surah.ayahs!) {
      String remainingText = ayah.text!;
      int currentIndex = 0;

      if (lastPage != null && ayah.page != lastPage) {
        spans.add(TextSpan(
            text: "\nالحزب: ${ayah.hizbQuarter}  ",
            style: TextStyle(
              fontSize: 10.sp,
              color: colorCondition,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: " ──────────── ${ayah.page} ──────────── ",
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

      while (currentIndex < remainingText.length) {
        bool wordFound = false;

        for (var word in wordsToHighlight) {
          if (remainingText.startsWith(word, currentIndex)) {
            spans.add(
              TextSpan(
                text: remainingText.substring(0, currentIndex),
                style: TextStyle(color: colorCondition),
              ),
            );

            // Add the word in red
            spans.add(
              TextSpan(
                text: word,
                style: const TextStyle(color: Colors.red),
              ),
            );

            // Update remaining text
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

      // Add the remaining text
      spans.add(
        TextSpan(
          text: remainingText,
          style: TextStyle(color: colorCondition),
        ),
      );

      // Add the ayah number
      spans.add(
        TextSpan(
          text: " (${ayah.numberInSurah}) ",
          style: TextStyle(color: colorCondition),
        ),
      );

      spans.add(const TextSpan(text: " ")); // Add space between ayahs
      lastPage = ayah.page;
    }

    return spans;
  }
}

// class QuranPageWidget extends StatelessWidget {
//   final SurahModel surah;
//
//   const QuranPageWidget({super.key, required this.surah});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: RichText(
//             textAlign: TextAlign.center,
//             textDirection: TextDirection.rtl,
//             text: TextSpan(
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 fontFamily: 'Uthmanic',
//               ),
//               text: (surah.name == "سُورَةُ التَّوۡبَةِ" || surah.name == "سُورَةُ ٱلْفَاتِحَةِ")
//                   ? null
//                   : 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ\n',
//               children: _buildAyahTextWithPageSeparation(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<InlineSpan> _buildAyahTextWithPageSeparation() {
//     List<InlineSpan> spans = [];
//     int? lastPage;
//
//     for (var ayah in surah.ayahs!) {
//       if (lastPage != null && ayah.page != lastPage) {
//         spans.add(
//           TextSpan(
//             text: "\n──────────── ${ayah.page} ────────────\n",
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       }
//
//       spans.add(
//         TextSpan(text: "${ayah.text}  "), // وضع النص أولًا
//       );
//
//       spans.add(
//         TextSpan(text: "(${ayah.numberInSurah}) "), // وضع النص أولًا
//       );
//
//       // spans.add(
//       //   WidgetSpan(
//       //     alignment: PlaceholderAlignment.middle,
//       //     child: ayahSign(ayah.numberInSurah.toString()), // رقم الآية بعد النص
//       //   ),
//       // );
//
//       spans.add(const TextSpan(text: " ")); // إضافة مسافة بين الآيات
//       lastPage = ayah.page;
//     }
//
//     return spans;
//   }
// }
