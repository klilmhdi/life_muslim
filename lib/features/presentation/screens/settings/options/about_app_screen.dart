import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

class AboutMuslimLifeScreen extends StatelessWidget {
  const AboutMuslimLifeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buildAppBar(context, title: "حول تطبيق حياة المسلم", isLeading: false),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipOval(
                  child: SvgPicture.asset(
                    AppAssets.appIcon,
                    width: 45.w,
                    height: 45.h,
                  ),
                ),
                Text(
                  'تطبيق حياة المسلم\nدليلك اليومي المتكامل كمسلم',
                  style: TextStyle(fontSize: AppConsts.font14size, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '"حياة المسلم" هو تطبيق إسلامي شامل صُمم بعناية ليجمع كل ما يحتاجه المسلم في حياته اليومية، من القرآن الكريم إلى الأذكار والمواقيت والإشعارات والتواصل المجتمعي، بواجهة جميلة وسهلة الاستخدام.',
            ),
            const Divider(height: 30),
            sectionTitle('💡 الهدف من التطبيق'),
            const Text(
              'تم بناء التطبيق ليكون رفيق المسلم اليومي، يجمع بين الجانب الروحي والتفاعلي في واجهة سلسة وبتجربة مستخدم حديثة. من قراءة القرآن إلى التفاعل مع المسلمين حول العالم.',
            ),
            const Divider(height: 30),
            sectionTitle('🌟 الميزات: '),
            SizedBox(height: 5.h),
            Row(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppAssets.quranIcon,
                  width: 28.w,
                  height: 28.h,
                ),
                Text(
                  'القرآن الكريم',
                  style: TextStyle(fontSize: AppConsts.font15size, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            bulletPoint('عرض السور بصيغة مصحف المدينة (صفحات) أو بشكل قائمة آيات.'),
            bulletPoint('إمكانية التبديل بين طريقتي العرض (صفحات / قائمة آيات).'),
            bulletPoint('دعم كامل لحفظ المرجع الأخير (Bookmark) يشمل الآية، الصفحة، الجزء، والحزب.'),
            bulletPoint('عرض مؤشر عند وجود مرجع محفوظ في قائمة الأجزاء.'),
            SizedBox(height: 10.h),
            Row(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppAssets.kaabaIcon,
                  width: 28.w,
                  height: 28.h,
                ),
                Text(
                  'القبلة والمواقيت',
                  style: TextStyle(fontSize: AppConsts.font15size, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            bulletPoint('تحديد القبلة باستخدام البوصلة.'),
            bulletPoint('عرض مواقيت الصلاة اليومية والشهرية حسب موقعك.'),
            bulletPoint('نظام تحديد الموقع مع حفظ المدينة والدولة تلقائيًا.'),
            SizedBox(height: 10.h),
            sectionTitle('   🔔  الإشعارات والتنبيهات'),
            bulletPoint('اشعار يومي متكرر للصلاة على النبي ﷺ.'),
            bulletPoint('إشعار يومي للتذكير بمواعيد الصلاة.'),
            SizedBox(height: 10.h),
            Row(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppAssets.sunnahIcon,
                  width: 28.w,
                  height: 28.h,
                ),
                Text(
                  'مجمع الأدعية والأذكار',
                  style: TextStyle(fontSize: AppConsts.font15size, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            bulletPoint(
                'توفر أدعية عديدة, مثل: أدعية من القرآن الكريم والسنة النبوية, أسماء الله الحسنى, والعديد من الأدعية والأذكار.'),
            SizedBox(height: 10.h),
            Row(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppAssets.sabaIcon,
                  width: 28.w,
                  height: 28.h,
                ),
                Text(
                  'التسبيح والإستغفار',
                  style: TextStyle(fontSize: AppConsts.font15size, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            bulletPoint('يمكنك التسبيح وحفظ اخر عدد سبحت به.'),
          ],
        ),
      ),
    ),
  );
}

Widget sectionTitle(String title) => Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    );

Widget bulletPoint(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("•  ", style: TextStyle(fontSize: 14.sp)),
          Expanded(child: Text(text)),
        ],
      ),
    );
