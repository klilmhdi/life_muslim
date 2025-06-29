import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_display/ayah_list_card_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_quran_display/quran_page_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../manage/change_ayah_display/change_ayah_display_cubit.dart';

class AyahScreen extends StatelessWidget {
  final SurahModel surah;

  const AyahScreen({super.key, required this.surah});

  // bool isBookView = true;
  @override
  Widget build(BuildContext context) {
    final displayMode = context.watch<ChangeAyahDisplayCubit>().state.displayMode;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.aqsaBackgroundImage),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            buildSilverAppBar(
              context,
              title: surah.name ?? "Surah",
            ),
            if (displayMode == AyahDisplayMode.page) ...[
              SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  child: QuranPageWidget(surah: surah),
                ),
              )
            ] else ...[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AyahListCardWidget(surah: surah),
                  childCount: 1,
                  addAutomaticKeepAlives: true,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
