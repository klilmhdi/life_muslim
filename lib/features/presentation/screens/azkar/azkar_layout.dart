import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/manage/azkar/general_azkar/azkar_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/40_hadith_nawawi/nawawi_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/general_azkar/azkar_grid_view_widget.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/quran_azkar/quran_azkar_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/roqaia/roqaia_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/sunnah_azkar/sunnah_azkar_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_button/buttons.dart';

import '../../../../core/utils/assets/assets.dart';
import '../../manage/azkar/hijjah/hijjah_bloc.dart';
import '../../manage/azkar/name_of_allah/name_of_allah_bloc.dart';
import '../../manage/azkar/nawawi/nawawi_bloc.dart';
import '../../manage/azkar/quran_ad3ea/quran_ad3ea_bloc.dart';
import '../../manage/azkar/roqaia/roqaia_bloc.dart';
import '../../manage/azkar/sunnah_ad3ea/sunnah_ad3ea_bloc.dart';
import '../../widgets/custom_appbar/build_appbar.dart';
import 'dhu_al_hijjah/nawawi_screen.dart';
import 'name_of_allah/name_of_allah_grid_view_widget.dart';

class AzkarLayout extends StatelessWidget {
  const AzkarLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "أدعية وأذكار", isLeading: false),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.fifthBackgroundImage),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              DelayedDisplay(
                delay: const Duration(milliseconds: 3),
                child: BlocBuilder<QuranAzkarBloc, QuranAzkarState>(
                  builder: (context, state) {
                    if (state is QuranAzkarLoaded) {
                      return azkarButton(
                        title: "أدعية من \nالقرآن الكريم",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          QuranAzkarScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 310),
                child: BlocBuilder<SunnahAzkarBloc, SunnahAzkarState>(
                  builder: (context, state) {
                    if (state is SunnahAzkarLoaded) {
                      return azkarButton(
                        title: "أدعية من \nالسنة النبوية",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          SunnahAzkarScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 350),
                child: BlocBuilder<HijjahBloc, HijjahState>(
                  builder: (context, state) {
                    if (state is HijjahLoaded) {
                      return azkarButton(
                        title: "أدعية ذي الحجة",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          HijjahScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 320),
                child: BlocBuilder<RoqaiaBloc, RoqaiaState>(
                  builder: (context, state) {
                    if (state is RoqaiaLoaded) {
                      return azkarButton(
                        title: "الرقية الشرعية",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          RoqaiaScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 330),
                child: BlocBuilder<AzkarBloc, AzkarState>(
                  builder: (context, state) {
                    if (state is AzkarLoaded) {
                      return azkarButton(
                        title: "مجمع الأذكار",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          GeneralAzkarScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 340),
                child: BlocBuilder<NameOfAllahBloc, NameOfAllahState>(
                  builder: (context, state) {
                    if (state is NameOfAllahLoaded) {
                      return azkarButton(
                        title: "أسماء الله \nالحسنى",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          NameOfAllahScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 350),
                child: BlocBuilder<NawawiBloc, NawawiState>(
                  builder: (context, state) {
                    if (state is NawawiLoaded) {
                      return azkarButton(
                        title: "أحاديث النووي \nالأربعون",
                        onTapped: () => navToWithRTLAnimation(
                          context,
                          NawawiScreen(azkar: state.azkarData),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
