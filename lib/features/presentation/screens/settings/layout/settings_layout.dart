import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_divider/build_divider_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/custom_menu_list_tile.dart';
import 'package:quran_life_muslim/features/presentation/widgets/open_protofolio_inappwebview/open_inappwebview_widget.dart';

class SettingsLayout extends StatelessWidget {
  const SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات العامة"),
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Center(
        child: Column(
          children: [
            customListTile(AppAssets.languageIcon, "اللغة وحجم النص"),
            const SizedBox(height: 10,),
            // buildWideDivider(),
            customListTile(AppAssets.notificationIcon, "الإشعارات"),
            // buildWideDivider(),
            const SizedBox(height: 10,),
            customListTile(AppAssets.reminderIcon, "التذكيرات"),
            // buildWideDivider(),
            // customListTile(AppAssets.settingsIcon, "شروط الاستخدام"),
            // buildWideDivider(),
            // customListTile(AppAssets.settingsIcon, "سياسة الخصوصية"),
            // buildWideDivider(),
            const SizedBox(height: 10,),
            customListTile(
              AppAssets.aboutMeIcon,
              "عن المطور",
              onTap: () => openWebPage(context, 'https://khlilmhdi-2c480.web.app/'),
            ),
            // buildWideDivider(),
            const SizedBox(height: 10,),
            customListTile(AppAssets.rateMeIcon, "قيمنا"),
            // buildWideDivider(),
          ],
        ),
      ),
    );
  }
}
