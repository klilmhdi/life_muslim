import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/presentation/screens/layout/layout.dart';
import 'package:quran_life_muslim/features/presentation/widgets/build_backgrounds/build_background_widget.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_button/buttons.dart';

class GetstartedScreen extends StatelessWidget {
  final Future<void> Function() onFinished;

  const GetstartedScreen({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConsts.basicAppColor,
              AppConsts.secondaryAppColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              buildBackgroundWidget(background: AppAssets.firstBackgroundImage, color: Colors.white),
              buildBackgroundWidget(background: AppAssets.secondBackgroundImage, color: Colors.white),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isPortrait ? 20.w : 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(),
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isPortrait ? 20.w : 30.w),
                      child: basicButton(
                        height: !isPortrait ? 100 : 60,
                        fontSize: !isPortrait ? AppConsts.font16size : AppConsts.font15size,
                        // onPressed: onFinished,
                        onPressed: () {
                          onFinished(); // Save the first launch state
                          // Navigate using the context from the button press
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const Layout()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        text: "ابدأ التطبيق",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: AppConsts.basicDarkAppColor,
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: CupertinoColors.white,
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: SvgPicture.asset(AppAssets.icon),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Column(
            children: [
              Text(
                "مرحباً بك في تطبيق",
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConsts.basicDarkAppColor,
                ),
              ),
              Text(
                "حياة المسلم",
                style: TextStyle(
                  fontSize: 45.sp,
                  fontFamily: AppConsts.reemKufi,
                  fontWeight: FontWeight.w400,
                  color: AppConsts.basicDarkAppColor,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildLandscapeLayout() => Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: AppConsts.basicDarkAppColor,
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: CupertinoColors.white,
                child: Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: SvgPicture.asset(
                    AppAssets.icon,
                  ),
                ),
              ),
            ],
          ),
          RichText(
              text: TextSpan(
                  text: "مرحباً بك في تطبيق ",
                  style: TextStyle(
                    fontSize: AppConsts.font16size,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppConsts.tajawal,
                    color: AppConsts.basicDarkAppColor,
                  ),
                  children: [
                TextSpan(
                  text: "حياة المسلم",
                  style: TextStyle(
                    fontSize: AppConsts.font25size,
                    fontFamily: AppConsts.reemKufi,
                    fontWeight: FontWeight.w400,
                    color: AppConsts.basicDarkAppColor,
                  ),
                ),
              ]))
        ],
      );
}
