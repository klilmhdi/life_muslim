import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/data/models/azkar/nawawi_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_dialog/custom_dialog_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/azkar_list_tile_widget.dart';

class NawawiScreen extends StatelessWidget {
  final List<NawawiModel> azkar;

  const NawawiScreen({super.key, required this.azkar});

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
                title: item.hadith ?? "",
                isTrailing: false,
                onTapped: () => showDialog(
                  context: context,
                  builder: (context) => NotificationDialog.azkarDialog(
                    context,
                    type: 2,
                    id: "${index + 1}",
                    name: "شرح وفوائد الحديث",
                    description: item.description ?? "",
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
