import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_divider/build_divider_widget.dart';

import '../../../manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';

class ChangeNotificationScreen extends StatefulWidget {
  const ChangeNotificationScreen({super.key});

  @override
  State<ChangeNotificationScreen> createState() => _ChangeAyahDisplayScreenState();
}

class _ChangeAyahDisplayScreenState extends State<ChangeNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "إعدادات الإشعارات", isLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 10,
          children: [
            _buildPrayerNotifications(context),
            buildWideDivider(),
            _buildProphetNotifications(context),
            buildWideDivider(),
            _buildSurahKahfNotification(context),
            buildWideDivider(),
            _buildMorningAdhkarNotification(context),
            buildWideDivider(),
            _buildEveningAdhkarNotification(context),
            // _buildAdvancedSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerNotifications(BuildContext context) {
    return BlocBuilder<PrayerTimingsBloc, PrayerTimingsState>(
      builder: (context, state) {
        final enabled = state is PrayerTimingsLoaded ? state.notificationsEnabled : false;

        return SwitchListTile(
          title: const Text(
            'تمكين إشعارات الأذان',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('تلقي تنبيه عند دخول وقت كل صلاة'),
          value: enabled,
          onChanged: (value) async {
            if (value) {
              _showEnableDialog(context);
            } else {
              context.read<PrayerTimingsBloc>().add(DisablePrayerNotifications());
            }
          },
        );
      },
    );
  }

  Widget _buildProphetNotifications(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'التذكير كل ساعة',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('إشعار كل ساعة للصلاة على النبي محمد ﷺ'),
      value: context.select((PrayerTimingsBloc bloc) =>
          bloc.state is PrayerTimingsLoaded ? (bloc.state as PrayerTimingsLoaded).notificationsEnabled : false),
      onChanged: (value) {
        // يمكن التحكم به بشكل منفصل إذا أردت
      },
    );
  }

  Widget _buildSurahKahfNotification(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'تذكير سورة الكهف',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('تذكير بقراءة سورة الكهف يوم الجمعة الساعة 10 صباحًا'),
      value: context.select((PrayerTimingsBloc bloc) =>
          bloc.state is PrayerTimingsLoaded ? (bloc.state as PrayerTimingsLoaded).notificationsEnabled : false),
      onChanged: (value) {
        // يمكن التحكم به بشكل منفصل إذا أردت
      },
    );
  }

  Widget _buildMorningAdhkarNotification(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'تذكير أذكار الصباح',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('تذكير بأذكار الصباح بعد صلاة الفجر بنصف ساعة'),
      value: context.select((PrayerTimingsBloc bloc) =>
          bloc.state is PrayerTimingsLoaded ? (bloc.state as PrayerTimingsLoaded).notificationsEnabled : false),
      onChanged: (value) {
        // يمكن التحكم به بشكل منفصل إذا أردت
      },
    );
  }

  Widget _buildEveningAdhkarNotification(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'تذكير أذكار المساء',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('تذكير بأذكار المساء قبل صلاة المغرب بساعة'),
      value: context.select((PrayerTimingsBloc bloc) =>
          bloc.state is PrayerTimingsLoaded ? (bloc.state as PrayerTimingsLoaded).notificationsEnabled : false),
      onChanged: (value) {
        // يمكن التحكم به بشكل منفصل إذا أردت
      },
    );
  }

  void _showEnableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تمكين الإشعارات'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('لتلقي إشعارات الأذان، يرجى التأكد من:'),
            SizedBox(height: 8),
            Text('• تفعيل الإشعارات في إعدادات الجهاز'),
            Text('• عدم إغلاق التطبيق بالكامل'),
            Text('• تمكين تشغيل الخلفية'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final state = context.read<PrayerTimingsBloc>().state;
              if (state is PrayerTimingsLoaded) {
                context
                    .read<PrayerTimingsBloc>()
                    .add(ScheduleNotificationsIfEnabled(state.timings.toTimeMap(), timingsModel: state.timings));
              }
            },
            child: const Text('تمكين'),
          ),
        ],
      ),
    );
  }
}