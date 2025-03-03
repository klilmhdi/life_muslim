import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/assets/assets.dart';
import '../../../../core/utils/functions/functions.dart';
import '../../../data/models/quran/surah_model.dart';
import '../../screens/quran/juz_screen.dart';

class PartsList extends StatelessWidget {
  final List<String> parts = List.generate(30, (index) => 'الجزء (${index + 1})');
  final List<SurahModel> surahs;

  PartsList({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppAssets.aqsaBackgroundImage), fit: BoxFit.cover, opacity: 0.3)),
      child: SafeArea(
        child: ListView.builder(
          itemCount: parts.length,
          itemBuilder: (context, index) {
            return Card(
              surfaceTintColor: Colors.deepPurple,
              elevation: 13,
              color: Colors.transparent,
              shape: const ContinuousRectangleBorder(),
              shadowColor: Colors.transparent,
              child: ListTile(
                leading: Image.asset(AppAssets.juzIcon, width: 40.w, height: 40.h,),
                title: Text(
                  parts[index],
                  style: TextStyle(fontFamily: 'Uthmanic', fontSize: 22.sp),
                ),
                // subtitle: Text("المنزلة: ${surahs[index].ayahs![index].manzil.toString()}"),
                onTap: () => navToWithLTRAnimation(
                    context, AyahJuzPage(surahs: surahs, partNumber: index + 1)),
              ),
            );
          },
        ),
      ),
    );
  }
}
