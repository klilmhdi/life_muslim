import 'package:flutter/material.dart';
import 'package:quran_life_muslim/features/data/models/azkar/quran_azkar_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/azkar_list_tile_widget.dart';

import '../../../../../core/utils/assets/assets.dart';

class QuranAzkarScreen extends StatelessWidget {
  final List<QuranAzkarModel> azkar;

  const QuranAzkarScreen({super.key, required this.azkar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, title: "أدعية من القرآن الكريم", isLeading: false),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.fifthBackgroundImage),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              final item = azkar[index];
              return azkarListTile(context, title: item.text ?? "", isTrailing: false, subtitle: item.info);
            },
          ),
        ),
      ),
    );
  }
}
