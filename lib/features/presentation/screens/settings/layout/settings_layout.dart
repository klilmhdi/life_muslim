import 'package:flutter/material.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/options/about_app_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/options/change_ayah_display_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/options/change_notification_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/options/check_location_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/custom_menu_list_tile.dart';

class SettingsLayout extends StatelessWidget {
  const SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات العامة"),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            spacing: 10,
            children: [
              customListTile(
                AppAssets.languageIcon,
                "اللغة وحجم النص",
                isSoon: true,
              ),
              customListTile(
                AppAssets.changePageIcon,
                "تغيير عرض الآيات",
                onTap: () => navToWithRTLAnimation(context, ChangeAyahDisplayScreen()),
                isSoon: false,
              ),
              customListTile(
                AppAssets.notificationIcon,
                "الإشعارات",
                isSoon: false,
                onTap: () => navToWithRTLAnimation(context, ChangeNotificationScreen()),
              ),
              customListTile(
                AppAssets.locationIcon,
                "الموقع",
                isSoon: false,
                onTap: () => navToWithRTLAnimation(context, LocationSettingsScreen()),
              ),
              customListTile(
                AppAssets.reminderIcon,
                "التذكيرات",
                isSoon: true,
              ),
              customListTile(
                AppAssets.appInfoIcon,
                "حول التطبيق",
                isSoon: false,
                onTap: () => navToWithRTLAnimation(context, AboutMuslimLifeScreen()),
              ),
              // customListTile(
              //   AppAssets.aboutMeIcon,
              //   "عن المطور",
              //   onTap: () => openWebPage(context, 'https://khlilmhdi-2c480.web.app/'),
              //   isSoon: false,
              // ),
              customListTile(
                AppAssets.rateMeIcon,
                "قيمنا",
                isSoon: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
