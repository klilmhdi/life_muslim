import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared_preferenced/shared_preferenced.dart';
import '../../../../core/utils/assets/assets.dart';
import '../../../../core/utils/consts/app_consts.dart';
import '../../../../core/utils/functions/functions.dart';
import '../../../data/models/quran/surah_model.dart';
import '../../manage/bookmark/bookmark_bloc.dart';
import '../../screens/quran/juz_screen.dart';

class PartsList extends StatelessWidget {
  final List<String> parts = List.generate(30, (index) => 'الجزء (${index + 1})');
  final List<SurahModel> surahs;

  PartsList({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarkBloc(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.aqsaBackgroundImage),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final partNumber = index + 1;
              final partName = "الجزء ${numberToArabicWords(partNumber)}";
              final manzil =
                  (index < surahs.length && surahs[index].ayahs != null && index < surahs[index].ayahs!.length)
                      ? surahs[index].ayahs![index].manzil.toString()
                      : "1";

              return BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, state) {
                  return FutureBuilder<int?>(
                    future: SharedPrefController.getBookmarkedPage(partNumber),
                    builder: (context, snapshot) {
                      final hasBookmark = snapshot.hasData && snapshot.data != null;

                      return Card(
                        surfaceTintColor: AppConsts.basicAppColor,
                        elevation: 13,
                        color: Colors.transparent,
                        shape: const ContinuousRectangleBorder(),
                        shadowColor: Colors.transparent,
                        child: ListTile(
                          leading: Image.asset(AppAssets.juzIcon, width: 40.w, height: 40.h),
                          title: Text(
                            partName,
                            style: TextStyle(
                              fontFamily: AppConsts.uthmanic,
                              fontSize: MediaQuery.orientationOf(context) == Orientation.portrait
                                  ? AppConsts.font20size
                                  : AppConsts.font18size,
                            ),
                          ),
                          trailing: Visibility(
                            visible: hasBookmark,
                            child: const Icon(
                              Icons.bookmarks_rounded,
                              color: AppConsts.quranIndicatorColor,
                            ),
                          ),
                          subtitle: Text("المنزلة: $manzil"),
                          onTap: () {
                            final initialPage = hasBookmark ? snapshot.data! : 0;
                            navToWithLTRAnimation(
                              context,
                              AyahJuzPage(
                                surahs: surahs,
                                partNumber: partNumber,
                                partTitle: partName,
                                initialPage: initialPage,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
