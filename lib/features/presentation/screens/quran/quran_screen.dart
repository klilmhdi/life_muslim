import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/quran/quran_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../widgets/build_quran_sections_list_view/parts_list_widget.dart';
import '../../widgets/build_quran_sections_list_view/surah_list_widget.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(
          context,
          title: "القرآن الكريم",
          isLeading: false,
          font: 'Uthmanic',
          isBottom: true,
        ),
        body: BlocBuilder<QuranBloc, QuranState>(builder: (context, state) {
          if (state is QuranLoaded) {
            return TabBarView(
              children: [const SurahList(), PartsList(surahs: state.quranData.data?.surahs ?? [])],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
