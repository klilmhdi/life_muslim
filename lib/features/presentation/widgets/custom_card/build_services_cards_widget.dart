// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quran_life_muslim/core/utils/assets/assets.dart';
// import 'package:quran_life_muslim/core/utils/functions/functions.dart';
// import 'package:quran_life_muslim/features/presentation/screens/qebla_compass/qeblah_compass_screen.dart';
// import 'package:quran_life_muslim/features/presentation/screens/quran/quran_screen.dart';
//
// class BuildServicesCardsWidget extends StatelessWidget {
//   const BuildServicesCardsWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       scrollDirection: Axis.horizontal,
//       children: [
//         _buildServiceCard(
//           context,
//           title: "القرآن الكريم",
//           image: AppAssets.quranIcon,
//           screen: const QuranScreen(),
//         ),
//         _buildServiceCard(
//           context,
//           title: "أدعية وأذكار",
//           image: AppAssets.sunnahIcon,
//           screen: const QuranScreen(),
//         ),
//         _buildServiceCard(
//           context,
//           title: "تحديد القِبْلة",
//           image: AppAssets.kaabaIcon,
//           screen: const QiblahScreen(),
//         ),
//         _buildServiceCard(
//           context,
//           title: "التسبيح والاستغفار",
//           image: AppAssets.sabaIcon,
//           screen: const QuranScreen(),
//         )
//       ],
//     );
//   }
//
//   _buildServiceCard(
//     BuildContext context, {
//     required String title,
//     required String image,
//     required Widget screen,
//   }) =>
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GestureDetector(
//           onTap: () => navTo(context, screen),
//           child: Container(
//             width: 120.w,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(
//                 color: Colors.deepPurple
//               )
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   image,
//                   width: 60.w,
//                   height: 60.h,
//                   fit: BoxFit.contain,
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/azkar_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/qebla_compass/qeblah_compass_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/quran/quran_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/tasbeeh/tasbeeh_screen.dart';

class BuildServicesCardsWidget extends StatelessWidget {
  const BuildServicesCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1,
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(
          context,
          title: service['title']!,
          image: service['image']!,
          screen: service['screen']!,
        );
      },
    );
  }

  List<Map<String, dynamic>> get _services => [
    {
      "title": "القرآن الكريم",
      "image": AppAssets.quranIcon,
      "screen": const QuranScreen(),
    },
    {
      "title": "أدعية وأذكار",
      "image": AppAssets.sunnahIcon,
      "screen": const AdhkarScreen(),
    },
    {
      "title": "تحديد القِبْلة",
      "image": AppAssets.kaabaIcon,
      "screen": const QiblahScreen(),
    },
    {
      "title": "التسبيح والاستغفار",
      "image": AppAssets.sabaIcon,
      "screen": const TasbeehScreen(),
    }
  ];

  Widget _buildServiceCard(
      BuildContext context, {
        required String title,
        required String image,
        required Widget screen,
      }) =>
      GestureDetector(
        onTap: () => navToWithRTLAnimation(context, screen),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.deepPurple),
          ),
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 60.w,
                height: 60.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
