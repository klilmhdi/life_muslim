import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';

import '../../../../core/utils/assets/assets.dart';
import '../../manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';

class NotificationDialog {
  static void showLocationPermissionDialog(context, {required void Function() reloadPage}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('مطلوب إذن الموقع'),
        content: const Text('يجب منح إذن الوصول إلى الموقع لتحديد القِبْلة.'),
        icon: const Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: CupertinoColors.black,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: CupertinoColors.white,
              child: Icon(CupertinoIcons.location, color: AppConsts.basicAppColor),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppConsts.basicDarkAppColor),
              shape: WidgetStatePropertyAll(
                ContinuousRectangleBorder(
                  side: const BorderSide(color: AppConsts.basicDarkAppColor, width: 2),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
            ),
            child: const Center(
                child:
                    Text('فتح الإعدادات', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              reloadPage();
            },
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(CupertinoColors.white),
              shape: WidgetStatePropertyAll(
                ContinuousRectangleBorder(
                  side: const BorderSide(color: AppConsts.basicAppColor, width: 2),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
            ),
            child: const Center(
                child: Text(
              'إعادة المحاولة',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
        ],
      ),
    );
  }

  static Widget azkarDialog(
    BuildContext context, {
    required String id,
    required String name,
    required String description,
    required int type,
  }) =>
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 15.h,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  type == 1 ? AppAssets.openBooks : AppAssets.nameOfAllahIcon,
                  height: 60.h,
                  width: 60.w,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$id.',
                      style: TextStyle(
                        fontSize: AppConsts.font16size,
                        color: AppConsts.basicDarkAppColor,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: MediaQuery.orientationOf(context) == Orientation.portrait
                            ? AppConsts.font22size
                            : AppConsts.font18size,
                        fontWeight: FontWeight.bold,
                        color: AppConsts.basicDarkAppColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: MediaQuery.orientationOf(context) == Orientation.portrait
                        ? AppConsts.font16size
                        : AppConsts.font14size,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  static Future<void> showNotificationDialog({
    required BuildContext context,
    required SharedPrefController sharedPrefController,
    required PrayerTimingsBloc prayerTimingsBloc,
  }) async {
    bool notificationsEnabled = await sharedPrefController.getNotificationsEnabled();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            title: const Text(
              'تفعيل الإشعارات الهامة',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'للحصول على أفضل تجربة، نوصي بتمكين الإشعارات للاستفادة من:',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 15.h),
                  _buildNotificationItem('🔔 تنبيهات دقيقة لأوقات الصلاة اليومية.'),
                  _buildNotificationItem('✨ تذكير بالصلاة على النبي ﷺ كل ساعة.'),
                  _buildNotificationItem('📖 تذكير بقراءة سورة الكهف يوم الجمعة.'),
                  _buildNotificationItem('🌅 تذكير بأذكار الصباح.'),
                  _buildNotificationItem('🌆 تذكير بأذكار المساء.'),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تمكين الإشعارات الآن؟',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Switch.adaptive(
                        value: notificationsEnabled,
                        onChanged: (value) {
                          setState(() => notificationsEnabled = value);
                        },
                        activeColor: AppConsts.basicAppColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  const Text(
                    '(يمكنك تغيير هذا الإعداد لاحقاً من صفحة الإعدادات)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        await sharedPrefController.setNotificationsDialogShown(true);
                        await sharedPrefController.setNotificationsEnabled(false);
                        Navigator.pop(context);
                        print("Notification dialog shown, user chose 'Later'. Notifications disabled.");
                      },
                      child: const Text('لاحقاً', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        await sharedPrefController.setNotificationsDialogShown(true);
                        await sharedPrefController.setNotificationsEnabled(notificationsEnabled);

                        if (notificationsEnabled) {
                          print("User enabled notifications. Triggering scheduling via bloc.");
                          final currentState = prayerTimingsBloc.state;
                          if (currentState is PrayerTimingsLoaded) {
                            prayerTimingsBloc.add(ScheduleNotificationsIfEnabled(currentState.timings.toTimeMap(),
                                timingsModel: currentState.timings));
                          } else {
                            print("Timings not loaded yet, scheduling will happen after fetch.");
                          }
                        } else {
                          print("User disabled notifications in the dialog.");
                          prayerTimingsBloc.add(DisablePrayerNotifications());
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConsts.basicAppColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: const Text(
                        'حفظ الإعداد',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildNotificationItem(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
}