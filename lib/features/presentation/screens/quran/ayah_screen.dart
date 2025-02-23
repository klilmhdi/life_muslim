import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_display/ayah_list_card_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_sign/ayah_sign_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../widgets/build_quran_display/quran_page_widget.dart';

class AyahScreen extends StatefulWidget {
  final SurahModel surah;

  const AyahScreen({Key? key, required this.surah}) : super(key: key);

  @override
  State<AyahScreen> createState() => _AyahScreenState();
}

class _AyahScreenState extends State<AyahScreen> with SingleTickerProviderStateMixin {
  bool isBookView = true;

  void _toggleView() => setState(() => isBookView = !isBookView);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context,
          title: widget.surah.name ?? "Surah",
          isLeading: false,
          font: 'Uthmanic',
          extraWidget: IconButton(
              onPressed: () => _toggleView(),
              icon: Icon(isBookView ? Icons.menu_book_rounded : Icons.table_rows_rounded))),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.aqsaBackgroundImage),
                fit: BoxFit.cover,
                opacity: 0.3)),
        child: widget.surah.ayahs == null || widget.surah.ayahs!.isEmpty
            ? const Center(child: Text("No Ayah data available"))
            : SafeArea(
              child: isBookView
                  ? QuranPageWidget(surah: widget.surah)
                  : AyahListCardWidget(surah: widget.surah),
            ),
      ),
    );
  }
}