import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/quran/quran_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/quran/ayah_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/ayah_sign_widget.dart';

import '../../../../core/utils/consts/app_consts.dart';

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
              child: BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, bookmarkState) {
                  return ListView.builder(
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];

                      final isBookmarked = bookmarkState.bookmarks.any(
                        (bookmark) =>
                            bookmark["surahName"] == surah.name &&
                            bookmark["ayahNumber"] == (surah.ayahs?.first.numberInSurah ?? 0),
                      );

                      return Card(
                        shape: const ContinuousRectangleBorder(),
                        surfaceTintColor: AppConsts.basicAppColor,
                        elevation: 13,
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          trailing: SizedBox(
                            width: 90,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isBookmarked)
                                  const Icon(Icons.bookmarks_rounded, color: AppConsts.quranIndicatorColor),
                                ayahSign(context, "${surah.number ?? 0}"),
                              ],
                            ),
                          ),
                          title: Text(
                            surah.name ?? "Unknown",
                            style: TextStyle(
                              fontFamily: AppConsts.uthmanic,
                              fontSize: AppConsts.font22size,
                            ),
                          ),
                          subtitle: Text.rich(
                            TextSpan(
                              text: surah.ayahs?.length.toString() ?? "0",
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
