import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';

import '../../../../core/utils/consts/app_consts.dart';
import '../../../data/models/quran/ayah_model.dart';
import '../../../data/models/quran/surah_model.dart';
import '../../screens/quran/ayah_screen.dart';

Widget buildStopCardWidget(BuildContext context, {required Color color}) {
  return BlocBuilder<BookmarkBloc, BookmarkState>(
    builder: (context, state) {
      Map<String, dynamic>? lastBookmark;
      if (state is BookmarksLoaded && state.bookmarks.isNotEmpty) {
        lastBookmark = state.bookmarks.last;
      }

      String? surahName = lastBookmark != null ? lastBookmark["surahName"] : null;
      int? ayahNumber = lastBookmark != null ? lastBookmark["ayahNumber"] : null;
      List<dynamic>? ayahsList = lastBookmark != null ? lastBookmark["ayahs"] : null;

      return GestureDetector(
        onTap: () {
          if (lastBookmark != null && ayahsList != null) {
            List<AyahsModel> ayahs = ayahsList.map((ayahJson) => AyahsModel.fromJson(ayahJson)).toList();
            navToDownToTop(context, AyahScreen(surah: SurahModel(name: surahName ?? "غير معروف", ayahs: ayahs)));
          }
        },
        child: SizedBox(
          height: MediaQuery.orientationOf(context) == Orientation.portrait ? 145.h : 220.h,
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.all(10.sp),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
            color: color,
            surfaceTintColor: AppConsts.skyBlueLightColor,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  image: const DecorationImage(
                      image: AssetImage(AppAssets.thirdBackgroundImage), fit: BoxFit.cover, opacity: 0.8)),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.book,
                                size: AppConsts.font18size,
                                color: CupertinoColors.white,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                lastBookmark != null ? "آخر موضع قراءة" : "لا توجد علامات مرجعية",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConsts.font14size,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (lastBookmark != null)
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  "إستكمال القراءة",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppConsts.font8size,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: CupertinoColors.white,
                                  size: AppConsts.font10size,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lastBookmark != null ? surahName ?? "غير معروف" : "اذهب لقراءة ورد من القرآن الكريم",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: lastBookmark != null ? AppConsts.font24size : AppConsts.font14size,
                                  fontFamily: lastBookmark != null ? AppConsts.uthmanic : AppConsts.tajawal,
                                ),
                              ),
                              Text(
                                lastBookmark != null
                                    ? "الآية رقم: (${ayahNumber ?? "?"})"
                                    : "ثم احفظ الآية التي تقف عندها",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: CupertinoColors.white,
                                  fontSize: lastBookmark != null ? AppConsts.font18size : AppConsts.font14size,
                                  fontFamily: lastBookmark != null ? AppConsts.uthmanic : AppConsts.tajawal,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            AppAssets.stopSurahImage,
                            height: 70.h,
                            width: 70.w,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
