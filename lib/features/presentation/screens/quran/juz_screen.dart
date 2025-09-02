import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/quran_page_sign_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/quran_quarter_sign_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_smooth_page_indicator/build_smooth_page_indicator_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_pop_up_menu/build_menu_pop_up_for_quran.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

import '../../../../core/app_cubit/app/app_cubit.dart';
import '../../../../core/utils/assets/assets.dart';
import '../../../../core/utils/consts/app_consts.dart';
import '../../../data/models/quran/quran_ayah_model.dart';
import '../../widgets/build_quran_display/build_juz_content_widget.dart';

class AyahJuzPage extends StatefulWidget {
  final List<SurahModel> surahs;
  final int partNumber;
  final String partTitle;
  final int initialPage;

  const AyahJuzPage(
      {super.key, required this.surahs, required this.partNumber, required this.partTitle, this.initialPage = 0});

  @override
  State<AyahJuzPage> createState() => _AyahJuzPageState();
}

class _AyahJuzPageState extends State<AyahJuzPage> {
  bool _isAppBarVisible = false;
  late final PageController _pageController;
  late List<AyahWithSurah> partAyahs;
  late Map<int, List<AyahWithSurah>> ayahsByPage;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    partAyahs = _loadPartAyahs();
    ayahsByPage = _groupAyahsByPage(partAyahs);

    final pageKeys = ayahsByPage.keys.toList();
    final initialPageIndex = pageKeys.indexOf(widget.initialPage);
    _pageController = PageController(initialPage: initialPageIndex >= 0 ? initialPageIndex : 0);
    _pageController.addListener(_updateCurrentPage);
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    super.dispose();
  }

  List<AyahWithSurah> _loadPartAyahs() {
    final List<AyahWithSurah> loadedAyahs = [];
    for (var surah in widget.surahs) {
      for (var ayah in surah.ayahs!) {
        if (ayah.juz == widget.partNumber) {
          loadedAyahs.add(AyahWithSurah(surah: surah, ayah: ayah));
        }
      }
    }
    return loadedAyahs;
  }

  Map<int, List<AyahWithSurah>> _groupAyahsByPage(List<AyahWithSurah> ayahs) {
    final Map<int, List<AyahWithSurah>> groupedAyahs = {};
    for (var ayahWithSurah in ayahs) {
      final page = ayahWithSurah.ayah.page!;
      if (!groupedAyahs.containsKey(page)) {
        groupedAyahs[page] = [];
      }
      groupedAyahs[page]!.add(ayahWithSurah);
    }
    return groupedAyahs;
  }

  void _updateCurrentPage() {
    final newPageIndex = _pageController.page?.round() ?? 0;
    if (newPageIndex != currentPageIndex) {
      setState(() => currentPageIndex = newPageIndex);
    }
  }

  void _toggleAppBar() => setState(() => _isAppBarVisible = !_isAppBarVisible);

  // void _togglePageBookmark() {
  //   final pageKeys = ayahsByPage.keys.toList();
  //   final currentPage = pageKeys.isNotEmpty ? pageKeys[currentPageIndex] : 0;
  //
  //   context.read<BookmarkBloc>().add(SavePageBookmark(juzNumber: widget.partNumber, pageNumber: currentPage));
  //
  //   showCustomSnackBar(
  //     context: context,
  //     title: "تم حفظ الصفحة للعلامة المرجعية  بنجاح: $currentPage",
  //     duration: 3,
  //     type: MessageType.success,
  //   );
  // }
  //
  // void _removePageBookmark() {
  //   final pageKeys = ayahsByPage.keys.toList();
  //   final currentPage = pageKeys.isNotEmpty ? pageKeys[currentPageIndex] : 0;
  //
  //   context.read<BookmarkBloc>().add(RemovePageBookmark(juzNumber: widget.partNumber));
  //
  //   showCustomSnackBar(
  //     context: context,
  //     title: "تم إزالة العلامة المرجعية من الصفحة: $currentPage",
  //     duration: 3,
  //     type: MessageType.success,
  //   );
  //
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final pageKeys = ayahsByPage.keys.toList();
    final currentPage = pageKeys.isNotEmpty ? pageKeys[currentPageIndex] : 0;
    final currentAyahs = ayahsByPage[currentPage] ?? [];
    final currentQuarter = currentAyahs.isNotEmpty ? currentAyahs.first.ayah.hizbQuarter : 0;

    return BlocConsumer<BookmarkBloc, BookmarkState>(
      listener: (context, state) {
        if (state is PageBookmarkSaved) {
          showCustomSnackBar(
            context: context,
            title: "تم حفظ الصفحة ${currentPage} بنجاح",
            duration: 2,
            type: MessageType.success,
          );
        } else if (state is PageBookmarkRemoved) {
          showCustomSnackBar(
            context: context,
            title: "تم إزالة العلامة المرجعية من الصفحة ${currentPage}",
            duration: 2,
            type: MessageType.success,
          );
        }
      },
      builder: (context, state) {
        final isBookmarked = state.pageBookmarks[widget.partNumber.toString()] == currentPage;

        return Scaffold(
          appBar: _isAppBarVisible
              ? buildAppBar(
                  context,
                  title: widget.partTitle,
                  isLeading: false,
                  extraWidget: QuranJuzMenuOptionsWidget(
                    saveCurrentPage: () {
                      context.read<BookmarkBloc>().add(
                            SavePageBookmark(juzNumber: widget.partNumber, pageNumber: currentPage),
                          );
                    },
                    removeCurrentPageBookmark: () {
                      context.read<BookmarkBloc>().add(
                            RemovePageBookmark(juzNumber: widget.partNumber),
                          );
                    },
                    isCurrentPageBookmarked: isBookmarked,
                  ),
                )
              : null,
          extendBodyBehindAppBar: true,
          body: GestureDetector(
            onTap: _toggleAppBar,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.aqsaBackgroundImage),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Visibility(
                      visible: isBookmarked,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          AppAssets.bookmarkJuzIcon,
                          height: 150.h,
                          width: 150.w,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: ayahsByPage.length,
                            itemBuilder: (context, index) {
                              final page = pageKeys[index];
                              final ayahsForPage = ayahsByPage[page]!;
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.sp),
                                  child: Column(
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: AppConsts.uthmanic,
                                          ),
                                          children: buildJuzWidget(
                                            context,
                                            ayahsForPage,
                                            context.read<AppCubit>().state.themeCurrentIndex == 0
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.sp,
                            right: 8.sp,
                            bottom: MediaQuery.orientationOf(context) == Orientation.portrait ? 0.0 : 5.sp,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MediaQuery.orientationOf(context) == Orientation.portrait
                                  ? juzPageSignWidget(currentPage.toString())
                                  : RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: context.read<AppCubit>().state.themeCurrentIndex == 0
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold),
                                        text: "رقم الصفحة: ",
                                        children: [TextSpan(text: currentPage.toString())],
                                      ),
                                    ),
                              buildSmoothPageIndicator(
                                context,
                                isBookmarked: isBookmarked,
                                controller: _pageController,
                                count: ayahsByPage.length,
                                onClicked: (index) => setState(() => currentPageIndex = index),
                              ),
                              MediaQuery.orientationOf(context) == Orientation.portrait
                                  ? quranQuarterWidget(currentQuarter.toString())
                                  : RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: context.read<AppCubit>().state.themeCurrentIndex == 0
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        text: "رقم الحزب: ",
                                        children: [TextSpan(text: currentQuarter.toString())],
                                      ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// @override
// Widget build(BuildContext context) {
//   final pageKeys = ayahsByPage.keys.toList();
//   final currentPage = pageKeys.isNotEmpty ? pageKeys[currentPageIndex] : 0;
//   final currentAyahs = ayahsByPage[currentPage] ?? [];
//   final currentQuarter = currentAyahs.isNotEmpty ? currentAyahs.first.ayah.hizbQuarter : 0;
//
//   return BlocConsumer<AppCubit, AppState>(
//     listener: (context, state) {},
//     builder: (context, state) {
//       return FutureBuilder<bool>(
//           future: SharedPrefController.isPageBookmarked(
//             widget.partNumber,
//             currentPage,
//           ),
//           builder: (context, snapshot) {
//             final isBookmarked = snapshot.data ?? false;
//             return Scaffold(
//               appBar: _isAppBarVisible
//                   ? buildAppBar(
//                       context,
//                       title: widget.partTitle,
//                       isLeading: false,
//                       extraWidget: QuranJuzMenuOptionsWidget(
//                         saveCurrentPage: _togglePageBookmark,
//                         removeCurrentPageBookmark: _removePageBookmark,
//                         isCurrentPageBookmarked: isBookmarked,
//                       ),
//                     )
//                   : null,
//               extendBodyBehindAppBar: true,
//               body: GestureDetector(
//                 onTap: _toggleAppBar,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(AppAssets.aqsaBackgroundImage),
//                       fit: BoxFit.cover,
//                       opacity: 0.3,
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Stack(
//                       children: [
//                         Visibility(
//                           visible: isBookmarked,
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: SvgPicture.asset(
//                               AppAssets.bookmarkJuzIcon,
//                               height: 150.h,
//                               width: 150.w,
//                             ),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Expanded(
//                               child: PageView.builder(
//                                 controller: _pageController,
//                                 itemCount: ayahsByPage.length,
//                                 itemBuilder: (context, index) {
//                                   final page = pageKeys[index];
//                                   final ayahsForPage = ayahsByPage[page]!;
//                                   return SingleChildScrollView(
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 14.sp),
//                                       child: Column(
//                                         children: [
//                                           RichText(
//                                             textAlign: TextAlign.center,
//                                             text: TextSpan(
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontFamily: AppConsts.uthmanic,
//                                               ),
//                                               children: buildJuzWidget(
//                                                 context,
//                                                 ayahsForPage,
//                                                 state.themeCurrentIndex == 0 ? Colors.black : Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 left: 8.sp,
//                                 right: 8.sp,
//                                 bottom: MediaQuery.orientationOf(context) == Orientation.portrait ? 0.0 : 5.sp,
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   MediaQuery.orientationOf(context) == Orientation.portrait
//                                       ? juzPageSignWidget(currentPage.toString())
//                                       : RichText(
//                                           text: TextSpan(
//                                             style: TextStyle(
//                                                 color: state.themeCurrentIndex == 0 ? Colors.black : Colors.white,
//                                                 fontWeight: FontWeight.bold),
//                                             text: "رقم الصفحة: ",
//                                             children: [TextSpan(text: currentPage.toString())],
//                                           ),
//                                         ),
//                                   buildSmoothPageIndicator(
//                                     context,
//                                     isBookmarked: isBookmarked,
//                                     controller: _pageController,
//                                     count: ayahsByPage.length,
//                                     onClicked: (index) => setState(() => currentPageIndex = index),
//                                   ),
//                                   MediaQuery.orientationOf(context) == Orientation.portrait
//                                       ? quranQuarterWidget(currentQuarter.toString())
//                                       : RichText(
//                                           text: TextSpan(
//                                             style: TextStyle(
//                                               color: state.themeCurrentIndex == 0 ? Colors.black : Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                             text: "رقم الحزب: ",
//                                             children: [TextSpan(text: currentQuarter.toString())],
//                                           ),
//                                         ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           });
//     },
//   );
// }
}
