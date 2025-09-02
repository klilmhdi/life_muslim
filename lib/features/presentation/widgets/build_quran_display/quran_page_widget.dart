import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';

import '../../../../core/enums/message_type.dart';
import '../custom_snack_bar/snackbar_widget.dart';

class QuranPageWidget extends StatefulWidget {
  final SurahModel surah;

  const QuranPageWidget({super.key, required this.surah});

  @override
  State<QuranPageWidget> createState() => _QuranPageWidgetState();
}

class _QuranPageWidgetState extends State<QuranPageWidget> {
  final shortSurah = AppConsts.shortSurah;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkBloc>().add(GetBookmarks());
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isShortSurah = shortSurah.contains(widget.surah.name);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<AppCubit>(context)),
        BlocProvider.value(value: BlocProvider.of<BookmarkBloc>(context)),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return BlocConsumer<BookmarkBloc, BookmarkState>(
            listener: (context, quranState) {
              if (quranState is BookmarkError) {
                showCustomSnackBar(
                  context: context,
                  title: "حاول في وقت لاحق",
                  duration: 300,
                  type: MessageType.error,
                );
              }
            },
            builder: (context, quranState) {
              final bookmarks = quranState is BookmarksLoaded ? quranState.bookmarks : <Map<String, dynamic>>[];

              return SingleChildScrollView(
                child: Center(
                  heightFactor: isShortSurah
                      ? (widget.surah.ayahs!.length <= 20 && widget.surah.ayahs!.length > 15) ||
                              widget.surah.name == "سُورَةُ البَيِّنَةِ"
                          ? 1.3.h
                          : (widget.surah.ayahs!.length <= 15 && widget.surah.ayahs!.length > 10)
                              ? 1.65.h
                              : (widget.surah.ayahs!.length <= 10 && widget.surah.ayahs!.length > 6)
                                  ? 2.2.h
                                  : (widget.surah.ayahs!.length <= 6)
                                      ? 2.8.h
                                      : null
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Column(
                      children: [
                        if (widget.surah.name != "سُورَةُ التَّوۡبَةِ" &&
                            widget.surah.name != "سُورَةُ ٱلْفَاتِحَةِ") ...[
                          SelectableText(
                            AppConsts.bismillah,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppConsts.font18size,
                              fontWeight: FontWeight.bold,
                              color: appState.themeCurrentIndex == 0 ? Colors.black : Colors.white,
                              fontFamily: AppConsts.uthmanic,
                            ),
                          ),
                        ],
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: appState.themeCurrentIndex == 0 ? Colors.black : Colors.white,
                              fontFamily: AppConsts.uthmanic,
                            ),
                            children: buildQuranContentWidget(
                              appState.themeCurrentIndex == 0 ? Colors.black : Colors.white,
                              widget.surah.ayahs!.length <= 10,
                              widget.surah,
                              bookmarks: bookmarks,
                              onAyahTap: (ayah) {
                                print("<<<<<<< Tapped! >>>>>>>");
                                context.read<BookmarkBloc>().add(
                                      SaveBookmark(
                                        quranModel: widget.surah,
                                        surahName: widget.surah.name!,
                                        ayahs: widget.surah.ayahs!,
                                        selectedAyah: ayah,
                                      ),
                                    );
                              },
                            ),
                          ),
                          textAlign:
                              widget.surah.ayahs!.length < 20 || isShortSurah ? TextAlign.center : TextAlign.justify,
                        ),
                        SelectableText(
                          AppConsts.endSurah,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppConsts.font18size,
                            fontWeight: FontWeight.bold,
                            color: appState.themeCurrentIndex == 0 ? Colors.black : Colors.white,
                            fontFamily: AppConsts.uthmanic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

List<TextSpan> buildQuranContentWidget(
  Color defaultColor,
  bool defaultLength,
  SurahModel surah, {
  List<Map<String, dynamic>> bookmarks = const [],
  required Function(AyahsModel) onAyahTap,
}) {
  debugPrint("------------ Tapped! ------------");
  const wordsToHighlight = AppConsts.redWords;

  return surah.ayahs!.map((ayah) {
    final isBookmarked = bookmarks
        .any((bookmark) => bookmark["ayahNumber"] == ayah.numberInSurah && bookmark["surahName"] == surah.name);

    final words = ayah.text!.split(' ');
    final textSpans = <TextSpan>[];

    for (final word in words) {
      final isHighlighted = wordsToHighlight.any((w) => word.contains(w));

      textSpans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(
            color: isHighlighted ? Colors.red : defaultColor,
            fontWeight: FontWeight.bold,
            backgroundColor: isBookmarked ? CupertinoColors.systemYellow.withOpacity(0.5) : Colors.transparent,
            fontSize: defaultLength ? AppConsts.font25size : AppConsts.font18size,
          ),
        ),
      );
    }

    return TextSpan(children: [
      ...textSpans,
      TextSpan(
        text: "﴿${ayah.numberInSurah}﴾ ",
        style: TextStyle(
          color: CupertinoColors.destructiveRed,
          fontWeight: FontWeight.bold,
          fontSize: defaultLength ? AppConsts.font25size : AppConsts.font18size,
        ),
      ),
    ], locale: const Locale('ar'), recognizer: TapGestureRecognizer()..onTap = () => onAyahTap(ayah));
  }).toList();
}
