// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quran_life_muslim/core/utils/assets/assets.dart';
// import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../data/models/quran/surah_model.dart';
// import '../../quran/ayah_screen.dart';
//
// class BookmarksScreen extends StatefulWidget {
//   const BookmarksScreen({super.key});
//
//   @override
//   _BookmarksScreenState createState() => _BookmarksScreenState();
// }
//
// class _BookmarksScreenState extends State<BookmarksScreen> {
//   List<AyahsModel> bookmarks = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBookmarks();
//   }
//
//   /// **Load Bookmarks from SharedPreferences**
//   Future<void> _loadBookmarks() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bookmarksList = prefs.getStringList('bookmarks') ?? [];
//
//     setState(() {
//       bookmarks = bookmarksList.map((ayahJsonString) {
//         final decodedJson = jsonDecode(ayahJsonString);
//         return AyahsModel.fromJson(decodedJson);
//       }).toList();
//     });
//   }
//
//   /// **Remove Bookmark**
//   Future<void> _removeBookmark(AyahsModel ayah) async {
//     final prefs = await SharedPreferences.getInstance();
//     final bookmarksList = prefs.getStringList('bookmarks') ?? [];
//
//     final ayahJsonString = jsonEncode(ayah.toJson());
//
//     bookmarksList.remove(ayahJsonString);
//     await prefs.setStringList('bookmarks', bookmarksList);
//
//     // Reload bookmarks
//     _loadBookmarks();
//   }
//
//   /// **Navigate to Surah & Scroll to the Saved Ayah**
//   void _navigateToAyah(BuildContext context, AyahsModel ayah) {
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${ayah.numberInSurah!}");
//     final surah = SurahModel(
//       number: ayah.numberInSurah, // Replace this with the correct Surah Number
//       ayahs: [ayah], // This should be replaced with all Ayahs of the Surah
//     );
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AyahScreen(surah: surah, startAyahIndex: ayah.numberInSurah!),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("العلامات المرجعية")),
//       body: bookmarks.isEmpty
//           ? const Center(child: Text("لم يتم حفظ أي سورة أو آية لقائمة العلامات المرجعية"))
//           : ListView.builder(
//               itemCount: bookmarks.length,
//               itemBuilder: (context, index) {
//                 final ayah = bookmarks[index];
//
//                 return ListTile(
//                   onTap: () => _navigateToAyah(context, ayah),
//                   leading: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Image.asset(
//                         AppAssets.ayahNumberSignIcon,
//                         height: 35.h,
//                         width: 35.w,
//                       ),
//                       Text(
//                         ayah.numberInSurah.toString(),
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   title: Text(
//                     "سورة ...",
//                     style: TextStyle(
//                         fontSize: 18.sp, fontFamily: 'Uthmanic', fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     ayah.text ?? "No Text",
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       overflow: TextOverflow.visible,
//                       fontFamily: 'Uthmanic',
//                     ),
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.done_outline_rounded, color: Colors.green),
//                     onPressed: () => _removeBookmark(ayah),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/enums/message_type.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/screens/quran/ayah_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Map<String, dynamic>> savedBookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  /// **تحميل العلامات المرجعية بشكل آمن**
  Future<void> _loadBookmarks() async {
    final bookmarks = await SharedPrefController.getBookmarks();
    setState(() {
      savedBookmarks = bookmarks;
    });
  }

  /// **حذف علامة مرجعية**
  Future<void> _removeBookmark(String surahName, AyahsModel ayah) async {
    await SharedPrefController.removeBookmark(surahName, ayah);
    showCustomSnackBar(
        context: context, title: "تمت العملية بنجاح", duration: 3, type: MessageType.success);
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, title: "العلامات المرجعية", isLeading: false),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.aqsaBackgroundImage), fit: BoxFit.cover, opacity: 0.3)),
        child: savedBookmarks.isEmpty
            ? const Center(child: Text("لم يتم حفظ أي آيات في العلامات المرجعية"))
            : ListView.builder(
                itemCount: savedBookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = savedBookmarks[index];

                  if (!bookmark.containsKey("surahName") || !bookmark.containsKey("ayah")) {
                    return const SizedBox(); // ✅ تجنب الأخطاء بسبب بيانات غير صالحة
                  }

                  final String surahName = bookmark["surahName"];
                  final AyahsModel ayah = bookmark["ayah"];

                  return Card(
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                    elevation: 2,
                    color: Colors.transparent,
                    margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                    child: ListTile(
                      onTap: () => _navigateToAyah(context, surahName, ayah),
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            AppAssets.ayahNumberSignIcon,
                            height: 35.h,
                            width: 35.w,
                          ),
                          Text(
                            ayah.numberInSurah.toString(),
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
                          fontFamily: 'Uthmanic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        ayah.text ?? "No Text",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Uthmanic',
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle_rounded,
                            color: CupertinoColors.inactiveGray),
                        onPressed: () => _removeBookmark(surahName, ayah),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  /// **الانتقال إلى السورة مع التمرير إلى الآية المحددة**
  void _navigateToAyah(BuildContext context, String surahName, AyahsModel ayah) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AyahScreen(
    //       surah: SurahModel(
    //         number: ayah.numberInSurah,
    //         name: surahName,
    //         ayahs: [ayah], // ✅ يجب استبدالها بكل آيات السورة الحقيقية
    //       ),
    //       // startAyahIndex: ayah.numberInSurah ?? 0,
    //     ),
    //   ),
    // );
    navToWithLTRAnimation(context, AyahScreen(
      surah: SurahModel(
        number: ayah.numberInSurah,
        name: surahName,
        ayahs: [ayah], // ✅ يجب استبدالها بكل آيات السورة الحقيقية
      ),
      // startAyahIndex: ayah.numberInSurah ?? 0,
    ));
  }
}
