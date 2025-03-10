import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/ayah_sign_widget.dart';

class AyahListCardWidget extends StatefulWidget {
  final SurahModel surah;

  const AyahListCardWidget({super.key, required this.surah});

  @override
  State<AyahListCardWidget> createState() => _AyahListCardWidgetState();
}

class _AyahListCardWidgetState extends State<AyahListCardWidget>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    // safeStartIndex = widget.startAyahIndex.clamp(0, widget.surah.ayahs!.length - 1);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _scrollController = ScrollController();

    // WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToSavedAyah());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // void _saveBookmark(AyahsModel ayah) async {
  //   await SharedPrefController.saveBookmark(widget.surah.name ?? "Unknown Surah", ayah).then(
  //     (value) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Ayah bookmarked!')),
  //       );
  //     },
  //   );
  // }
  //
  // /// **الانتقال إلى الآية المحفوظة بدون تحريك**
  // void _jumpToSavedAyah() {
  //   if (widget.startAyahIndex >= 0 && widget.startAyahIndex < widget.surah.ayahs!.length) {
  //     double position = safeStartIndex * 100.0; // تعديل الارتفاع حسب الحاجة
  //     _scrollController.jumpTo(position);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Text(
              widget.surah.name == "سُورَةُ التَّوۡبَةِ" || widget.surah.name == "سُورَةُ ٱلْفَاتِحَةِ"
                  ? ""
                  : 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيم',
              style: TextStyle(
                fontFamily: 'Uthmanic',
                fontSize: 22.sp,
              ),
            ),
          ),
          ListView.builder(
            controller: _scrollController,
            itemCount: widget.surah.ayahs!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final ayah = widget.surah.ayahs![index];
              return GestureDetector(
                onTap: () {},
                child: Card(
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  elevation: 2,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  ayahSign(ayah.numberInSurah.toString())
                                ],
                              ),
                            ),
                            SizedBox(width: 4.h),
                            Expanded(
                              flex: 10,
                              child: Text(
                                ayah.text ?? "No Text",
                                style: TextStyle(
                                  fontFamily: 'Uthmanic',
                                  fontSize: 22.sp,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: Text('صدق الله العظيم\n',
              style: TextStyle(
                fontFamily: 'Uthmanic',
                fontSize: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
