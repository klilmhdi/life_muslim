import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/data/models/azkar/hijjah_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/azkar_list_tile_widget.dart';

class HijjahScreen extends StatelessWidget {
  final List<HijjahModel> azkar;

  const HijjahScreen({super.key, required this.azkar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "أحاديث النووي الأربعون", isLeading: false),
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
          child: ListView.builder(
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              final item = azkar[index];
              return azkarListTile(
                context,
                title: item.title ?? "",
                subtitle: item.source ?? "",
                isTrailing: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
