// import 'package:flutter/material.dart';
// import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';
// import 'package:quran_life_muslim/features/presentation/screens/quran/ayah_screen.dart';
//
// import '../custom_pop_up_menu/build_menu_pop_up_for_quran.dart';
//
// Widget customQuranListTile(BuildContext context, String surahName, SurahModel surah) => ListTile(
//   title: Text(surah.englishName ?? "Unknown"),
//   subtitle: Text(surah.name ?? "Unknown"),
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AyahScreen(surah: surah, startAyahIndex: 10,),
//       ),
//     );
//   },
//   trailing: const QuranMenuOptionsWidget(),
// );