import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';

class BuildServicesCardsWidget extends StatelessWidget {
  final bool isPortrait, isDark;

  const BuildServicesCardsWidget({super.key, required this.isPortrait, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isPortrait ? 2 : 4,
        crossAxisSpacing: isPortrait ? 8.w : 5.w,
        mainAxisSpacing: isPortrait ? 8.h : 5.w,
        childAspectRatio: isPortrait ? 1 : 1.5,
      ),
      itemCount: AppConsts.services.length,
      itemBuilder: (context, index) {
        final service = AppConsts.services[index];
        return _buildServiceCard(
          context,
          title: service['title'],
          image: service['image'],
          screen: service['screen'],
          lightColor: service['light_color'],
          darkColor: service['dark_color'],
          align: service['align'],
          isPortrait: isPortrait,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String image,
    required Widget screen,
    required Color lightColor,
    required Color darkColor,
    required int align,
    required bool isPortrait,
    required bool isDark,
  }) =>
      GestureDetector(
        onTap: () => navToWithRTLAnimation(context, screen),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.r),
              bottomRight: Radius.circular(35.r),
              topRight: Radius.circular(isPortrait ? 10.r : 6.r),
              bottomLeft: Radius.circular(isPortrait ? 10.r : 6.r),
            ),
            image: const DecorationImage(image: AssetImage(AppAssets.thirdBackgroundImage), fit: BoxFit.cover),
            gradient: LinearGradient(
              begin: Alignment(1, 7),
              end: Alignment(2, -8),
              colors: !isDark
                  ? align == 1
                      ? [darkColor.withValues(alpha: 1.4), AppConsts.basicDarkAppColor.withValues(alpha: 0.5)]
                      : [AppConsts.basicDarkAppColor.withValues(alpha: 0.5), darkColor.withValues(alpha: 1.4)]
                  : align == 1
                      ? [lightColor.withValues(alpha: 1.5), AppConsts.basicAppColor.withValues(alpha: 0.8)]
                      : [AppConsts.basicAppColor.withValues(alpha: 0.8), lightColor.withValues(alpha: 1.5)],
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: align == 1 ? Alignment.topLeft : Alignment.bottomRight,
                child: SvgPicture.asset(
                  image,
                  width: isPortrait ? 70.w : 40.w,
                  height: isPortrait ? 70.h : 100.h,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isPortrait ? 12.sp : 6.sp),
                child: Align(
                  alignment: align == 1 ? Alignment.bottomRight : Alignment.topLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: isPortrait ? AppConsts.font25size : AppConsts.font20size,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
