import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/data/models/azkar/name_of_allah_model.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_azkar_card.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_dialog/custom_dialog_widget.dart';

class NameOfAllahScreen extends StatelessWidget {
  final List<NameOfAllahModel> azkar;

  const NameOfAllahScreen({super.key, required this.azkar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "أسماء الله الحسنى", isLeading: false),
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
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.orientationOf(context) != Orientation.portrait ? 4 : 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.3,
            ),
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              final azkarCategory = azkar[index];
              return GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => NotificationDialog.azkarDialog(
                    context,
                    type: 1,
                    id: azkarCategory.id.toString(),
                    name: azkarCategory.name ?? "",
                    description: azkarCategory.text ?? "",
                  ),
                ),
                child: buildNameOfAllahCardWidget(
                  nameTitle: azkarCategory.name ?? "بدون عنوان",
                  nameId: azkarCategory.id.toString(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
