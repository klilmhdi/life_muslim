import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:quran_life_muslim/features/presentation/screens/quran/ayah_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_empty_widgets/build_empty_widgets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/ayah_sign_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

import '../../../../../core/utils/consts/app_consts.dart';
import '../../../../data/models/quran/surah_model.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Map<String, dynamic>> savedBookmarks = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await SharedPrefController.getBookmarks();
    setState(() {
      savedBookmarks = bookmarks;
    });
  }

  Future<void> _removeBookmark(int index, String surahName, AyahsModel ayah, page, juz) async {
    await SharedPrefController.removeBookmark(surahName, ayah.numberInSurah!);

    final removedItem = savedBookmarks.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
    );

    if (mounted) {
      showCustomSnackBar(
        context: context,
        title: "تمت العملية بنجاح",
        duration: 3,
        type: MessageType.success,
      );
    }

    if (savedBookmarks.isEmpty && mounted) {
      setState(() {});
    }
  }

  Widget _buildRemovedItem(Map<String, dynamic> item, Animation<double> animation) {
    final ayah = item["ayah"] as AyahsModel?;
    final surahName = item["surahName"] as String? ?? "غير معروف";
    final ayahNumber = ayah?.numberInSurah?.toString() ?? "?";

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
        elevation: 2,
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: ListTile(
          leading: ayahSign(context, ayahNumber),
          title: Text(
            surahName,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppConsts.uthmanic,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "رقم الصفحة: ${item['page']}",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppConsts.uthmanic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("|"),
              Text(
                "رقم الجزء: ${item['juz']}",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConsts.uthmanic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, title: "العلامات المرجعية", isLeading: false),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppAssets.aqsaBackgroundImage), fit: BoxFit.cover, opacity: 0.3)),
        child: savedBookmarks.isEmpty
            ? EmptyWidgets.bookmarkEmptyWidget()
            : AnimatedList(
                key: _listKey,
                initialItemCount: savedBookmarks.length,
                itemBuilder: (context, index, animation) {
                  final bookmark = savedBookmarks[index];

                  // فحص شامل للبيانات المطلوبة
                  if (bookmark == null || !bookmark.containsKey("surahName") || !bookmark.containsKey("selectedAyah")) {
                    return const SizedBox(); // أو عرض ويدجت بديلة للبيانات غير الصالحة
                  }

                  final String surahName = bookmark["surahName"] as String? ?? "غير معروف";
                  final AyahsModel? ayah = bookmark["selectedAyah"] as AyahsModel?;

                  if (ayah == null) {
                    return const SizedBox(); // أو عرض ويدجت بديلة للآية غير الموجودة
                  }

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    )),
                    child: Card(
                      shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
                      elevation: 2,
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: ListTile(
                        onTap: () => navToWithRTLAnimation(
                            context,
                            AyahScreen(
                              surah: SurahModel(
                                name: bookmark["surahName"],
                                ayahs: bookmark["ayahs"],
                              ),
                            )),
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
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
                              _removeBookmark(index, surahName, ayah, ayah.page, ayah.juz);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
