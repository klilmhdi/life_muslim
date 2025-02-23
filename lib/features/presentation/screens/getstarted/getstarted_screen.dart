import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/screens/layout/layout.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_button/buttons.dart';

class GetstartedScreen extends StatelessWidget {
  const GetstartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Image.asset(AppAssets.firstBackgroundImage, fit: BoxFit.cover, height: double.infinity),
            Image.asset(AppAssets.secondBackgroundImage, fit: BoxFit.cover, height: double.infinity),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("مرحباً بك في تطبيق",
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300)),
                Text("حياة المسلم", style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600)),
                Image.asset(
                  AppAssets.introMosqueImage,
                  height: 350.h,
                  width: 350.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: AwesomeButton(
                      onPressed: () => navAndFinish(context, const Layout()), text: "ابدأ التطبيق"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
