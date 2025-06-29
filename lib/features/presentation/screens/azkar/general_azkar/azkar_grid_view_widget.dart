import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/data/models/azkar/azkar_model.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/general_azkar/azkar_details_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_azkar_card.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_dialog/custom_dialog_widget.dart';

class GeneralAzkarScreen extends StatelessWidget {
  final List<AzkarModel> azkar;

  const GeneralAzkarScreen({super.key, required this.azkar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "مجمع الأذكار", isLeading: false),
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
              crossAxisCount: MediaQuery.orientationOf(context) == Orientation.portrait ? 2 : 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.3,
            ),
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              final azkarCategory = azkar[index];
              return GestureDetector(
                onTap: () => azkarCategory.array!.length == 1
                    ? showDialog(
                        context: context,
                        builder: (context) => NotificationDialog.azkarDialog(
                          context,
                          id: '',
                          name: azkarCategory.category ?? "",
                          description: azkarCategory.array!.first.text.toString(),
                          type: 1,
                        ),
                      )
                    : navToWithRTLAnimation(
                        context,
                        AzkarDetailsWidget(
                          azkar: azkarCategory.array!,
                          title: azkarCategory.category ?? "",
                        ),
                      ),
                child: buildAzkarCardWidget(
                  azkarTitle: azkarCategory.category ?? "بدون عنوان",
                  azkarNumber: "عدد الأذكار: (${azkarCategory.array?.length ?? 0})",
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
