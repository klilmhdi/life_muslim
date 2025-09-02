import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/quran/ayah_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_empty_widgets/build_empty_widgets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/ayah_sign_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

import '../../../../../core/utils/consts/app_consts.dart';
import '../../../../data/models/quran/surah_model.dart';

class BookmarksScreen extends StatelessWidget {
  BookmarksScreen({super.key});

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, title: "العلامات المرجعية", isLeading: false),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.aqsaBackgroundImage),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: BlocConsumer<BookmarkBloc, BookmarkState>(
          listener: (context, state) {
            if (state is BookmarkError) {
              showCustomSnackBar(context: context, title: state.error, type: MessageType.error, duration: 2);
            }
          },
          builder: (context, state) {
            if (state is BookmarksLoaded) {
              final savedBookmarks = state.bookmarks;
              if (savedBookmarks.isEmpty) {
                return EmptyWidgets.bookmarkEmptyWidget();
              }
              return _buildBookmarksList(savedBookmarks);
            } else if (state is BookmarkLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final savedBookmarks = state.bookmarks;
              return _buildBookmarksList(savedBookmarks);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBookmarksList(List<Map<String, dynamic>> savedBookmarks) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: savedBookmarks.length,
      itemBuilder: (context, index, animation) {
        final bookmark = savedBookmarks[index];

        if (bookmark == null || !bookmark.containsKey("surahName") || !bookmark.containsKey("selectedAyah")) {
          return const SizedBox();
        }

        final String surahName = bookmark["surahName"] as String? ?? "غير معروف";
        final Map<String, dynamic>? selectedAyahMap = bookmark["selectedAyah"] as Map<String, dynamic>?;

        final AyahsModel? ayah = selectedAyahMap != null ? AyahsModel.fromJson(selectedAyahMap) : null;

        if (ayah == null) {
          return const SizedBox();
        }

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: Card(
            shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
            elevation: 2,
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: ListTile(
              onTap: () {
                final List<dynamic>? ayahsList = bookmark["ayahs"] as List<dynamic>?;
                if (ayahsList != null) {
                  List<AyahsModel> ayahs = ayahsList.map((ayahJson) => AyahsModel.fromJson(ayahJson)).toList();

                  navToWithRTLAnimation(context, AyahScreen(surah: SurahModel(name: surahName, ayahs: ayahs)));
                }
              },
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.ayahNumberSignIcon,
                    height: 35.h,
                    width: 35.w,
                  ),
                  Text(
                    ayah.numberInSurah?.toString() ?? "?",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              title: Text(
                surahName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: AppConsts.uthmanic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                ayah.text ?? "لا يوجد نص",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppConsts.uthmanic,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.check_circle_rounded, color: CupertinoColors.inactiveGray),
                onPressed: () {
                  if (ayah.numberInSurah != null) {
                    _removeBookmark(context, index, surahName, ayah.numberInSurah!);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeBookmark(BuildContext context, int index, String surahName, int ayahNumber) {
    context.read<BookmarkBloc>().add(RemoveBookmark(surahName: surahName, ayahNumber: ayahNumber));

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildRemovedItem(context, surahName, ayahNumber, animation),
      duration: const Duration(milliseconds: 300),
    );

    showCustomSnackBar(context: context, title: "تمت العملية بنجاح", duration: 3, type: MessageType.success);
  }

  Widget _buildRemovedItem(context, String surahName, int ayahNumber, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        child: Card(
          shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
          elevation: 2,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: ListTile(
            leading: ayahSign(context, ayahNumber.toString()),
            title: Text(
              surahName,
              style: TextStyle(fontSize: 18.sp, fontFamily: AppConsts.uthmanic, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Text(
                  "تم إزالة العلامة المرجعية",
                  style: TextStyle(fontSize: 14.sp, fontFamily: AppConsts.uthmanic, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
}
