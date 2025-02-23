import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/features/data/models/azkar/array_azkar_model.dart';
import 'package:quran_life_muslim/features/presentation/screens/adhan/adhan_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../../../core/utils/assets/assets.dart';

class AdhkarDetailsScreen extends StatelessWidget {
  final List<ArrayAzkarModel> adhkar;
  final String title;

  const AdhkarDetailsScreen({super.key, required this.adhkar, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, title: title, isLeading: false),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.fourthBackgroundImage),
                fit: BoxFit.cover,
                opacity: 0.2)),
        child: SafeArea(
          child: ListView.builder(
            itemCount: adhkar.length,
            itemBuilder: (context, index) {
              final item = adhkar[index];
              return Card(
                surfaceTintColor: Colors.deepPurple,
                elevation: 13,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                child: ListTile(
                  title: Text(item.text ?? "", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 40.r, color: Colors.grey.shade500),
                      Text(item.count.toString(), style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold))
                    ],
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
