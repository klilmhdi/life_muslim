import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

class AboutMuslimLifeScreen extends StatelessWidget {
  const AboutMuslimLifeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SectionTitle('💡 الهدف من التطبيق'),
              const Text(
                'تم بناء التطبيق ليكون رفيق المسلم اليومي، يجمع بين الجانب الروحي والتفاعلي في واجهة سلسة وبتجربة مستخدم حديثة. من قراءة القرآن إلى التفاعل مع المسلمين حول العالم.',
              ),
              const Divider(height: 30),
              const SectionTitle('🌟 الميزات: '),
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
              const BulletPoint('عرض السور بصيغة مصحف المدينة (صفحات) أو بشكل قائمة آيات.'),
              const BulletPoint('إمكانية التبديل بين طريقتي العرض (صفحات / قائمة آيات).'),
              const BulletPoint('دعم كامل لحفظ المرجع الأخير (Bookmark) يشمل الآية، الصفحة، الجزء، والحزب.'),
              const BulletPoint('عرض مؤشر عند وجود مرجع محفوظ في قائمة الأجزاء.'),
              SizedBox(height: 10.h),
              Row(
                spacing: 5.w,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
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
              const BulletPoint('تحديد القبلة باستخدام البوصلة.'),
              const BulletPoint('عرض مواقيت الصلاة اليومية والشهرية حسب موقعك.'),
              const BulletPoint('نظام تحديد الموقع مع حفظ المدينة والدولة تلقائيًا.'),
              SizedBox(height: 10.h),
              const SectionTitle('   🔔  الإشعارات والتنبيهات'),
              const BulletPoint('اشعار يومي متكرر للصلاة على النبي ﷺ.'),
              const BulletPoint('إشعار يومي للتذكير بمواعيد الصلاة.'),
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
              const BulletPoint(
                  'توفر أدعية عديدة, مثل: أدعية من القرآن الكريم والسنة النبوية, أسماء الله الحسنى, والعديد من الأدعية والأذكار.'),
              SizedBox(height: 10.h),
              Row(
                spacing: 5.w,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
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
              const BulletPoint('يمكنك التسبيح وحفظ اخر عدد سبحت به.'),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
