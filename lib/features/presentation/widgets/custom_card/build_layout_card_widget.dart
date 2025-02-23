import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_services_cards_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_stop_card_widget.dart';

Widget LayoutCardWidget() => Card(
      child: Stack(
        children: [
          Image.asset(
            AppAssets.firstBackgroundImage,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Image.asset(
            AppAssets.secondBackgroundImage,
            fit: BoxFit.cover,
            height: double.infinity,
            opacity: const AlwaysStoppedAnimation(0.35),
          ),
          Column(
            children: [
              buildStopCardWidget(),
              const Expanded(child: BuildServicesCardsWidget()),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
