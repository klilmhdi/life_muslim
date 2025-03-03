import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/screens/adhan/adhan_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/calender/calender_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/layout/bookmarks_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/settings/layout/settings_layout.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_divider/build_divider_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_list_tile/custom_menu_list_tile.dart';

Widget customDrawer(context) => Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 300.h,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppAssets.drawerBackgroundImage), fit: BoxFit.cover)),
              child: SizedBox(),
            ),
          ),
          customListTile(
            AppAssets.bookmarkIcon,
            "العلامات المرجعية",
            onTap: () => navToWithRTLAnimation(context, BookmarksScreen()),
          ),
          buildWideDivider(),
          customListTile(
            AppAssets.favIcon,
            "المفضلة",
            // onTap: () => openWebPage(context, 'https://khlilmhdi-2c480.web.app/'),
          ),
          buildWideDivider(),
          customListTile(
            AppAssets.ramadanCalenderIcon,
            "التقويم الميلادي والهجري",
            onTap: () => navToWithLTRAnimation(context, const CalendarScreen()),
          ),
          buildWideDivider(),
          customListTile(
            AppAssets.settingsIcon,
            "الإعدادات العامة",
            onTap: () => navToWithLTRAnimation(context, const SettingsLayout()),
          ),
          // buildWideDivider(),
          // customListTile(
          //   Icons.account_box_outlined,
          //   "About developer",
          //   onTap: () => openWebPage(context, 'https://khlilmhdi-2c480.web.app/'),
          // )
        ],
      ),
    );
