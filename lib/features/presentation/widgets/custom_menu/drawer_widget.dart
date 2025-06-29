import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/layout/bookmarks_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/layout/settings_layout.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_divider/build_divider_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/custom_menu_list_tile.dart';

import '../../screens/settings/layout/adhan/athan_by_month_screen.dart';

Widget customDrawer(context) => Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 300.h,
            child: const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.drawerBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customListTile(
                    AppAssets.bookmarkIcon,
                    "العلامات المرجعية",
                    isSoon: false,
                    onTap: () => navToWithRTLAnimation(context, const BookmarksScreen()),
                  ),
                  buildWideDivider(),
                  customListTile(
                    AppAssets.favIcon,
                    "المفضلة",
                    isSoon: true,
                  ),
                  buildWideDivider(),
                  customListTile(
                    AppAssets.azanIcon,
                    "مواعيد الآذان",
                    isSoon: false,
                    onTap: () => navToWithRTLAnimation(context, const PrayerTimesScreen()),
                  ),
                  buildWideDivider(),
                  customListTile(
                    AppAssets.ramadanCalenderIcon, "التقويم الميلادي والهجري",
                    isSoon: true,
                    // onTap: () => navToWithLTRAnimation(context, const CalendarScreen()),
                  ),
                  buildWideDivider(),
                  customListTile(
                    AppAssets.ramadanImsakiaIcon,
                    "إمساكية رمضان",
                    isSoon: true,
                  ),
                  buildWideDivider(),
                  customListTile(
                    AppAssets.settingsIcon,
                    "الإعدادات العامة",
                    isSoon: false,
                    onTap: () => navToWithLTRAnimation(context, const SettingsLayout()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
