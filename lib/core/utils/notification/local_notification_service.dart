import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  /// Private variables
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool _isCustomSoundAvailable = false;

  /// Initialization
  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    await _configureLocalTimeZone();

    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isAndroid) {
      try {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation != null) {
          const AndroidNotificationChannel testChannel = AndroidNotificationChannel(
            'test_sound_channel_id',
            'Test Sound Channel',
            description: 'Channel to test if custom sounds work',
            importance: Importance.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('sound'),
          );
          await androidImplementation.createNotificationChannel(testChannel);

          const AndroidNotificationChannel prayerChannel = AndroidNotificationChannel(
            'prayer_channel_id',
            'أوقات الصلاة',
            description: 'إشعارات أوقات الصلاة اليومية',
            importance: Importance.max,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('prayer'),
            audioAttributesUsage: AudioAttributesUsage.alarm,
          );
          await androidImplementation.createNotificationChannel(prayerChannel);

          const AndroidNotificationChannel prophetReminderChannel = AndroidNotificationChannel(
            'repeating_channel_id',
            'تذكير الصلاة على النبي',
            description: 'إشعارات الصلاة على النبي كل ساعة',
            importance: Importance.defaultImportance,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('say'), // Custom sound for note
          );
          await androidImplementation.createNotificationChannel(prophetReminderChannel);

          // Create Surah Al-Kahf Channel
          const AndroidNotificationChannel kahfChannel = AndroidNotificationChannel(
            'kahf_channel_id',
            'سورة الكهف',
            description: 'تذكير بقراءة سورة الكهف يوم الجمعة',
            importance: Importance.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('note'),
          );
          await androidImplementation.createNotificationChannel(kahfChannel);

          const AndroidNotificationChannel morningAdhkarChannel = AndroidNotificationChannel(
            'morning_adhkar_channel_id',
            'أذكار الصباح',
            description: 'تذكير بأذكار الصباح',
            importance: Importance.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('morning'),
          );
          await androidImplementation.createNotificationChannel(morningAdhkarChannel);

          const AndroidNotificationChannel eveningAdhkarChannel = AndroidNotificationChannel(
            'evening_adhkar_channel_id',
            'أذكار المساء',
            description: 'تذكير بأذكار المساء',
            importance: Importance.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('night'),
          );
          await androidImplementation.createNotificationChannel(eveningAdhkarChannel);

          _isCustomSoundAvailable = true;
          print('Custom sound test successful - sound resources appear to be available');
        }
      } catch (e) {
        _isCustomSoundAvailable = false;
        print('Custom sound test failed - sound resources may not be available: $e');
        print('Notifications will be scheduled without custom sound');
      }
    }

    _isInitialized = true;
    print('Notification Service Initialized');
  }

  /// Configure local timezone
  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux || Platform.isWindows) {
      return;
    }
    tz.initializeTimeZones();
    try {
      final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
      if (timeZoneName != null && timeZoneName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        print('Timezone set to: $timeZoneName');
      } else {
        print('Could not get local timezone name.');
      }
    } catch (e) {
      print('Error configuring timezone: $e');
    }
  }

  /// Permission Handling
  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImplementation?.areNotificationsEnabled();
      if (granted == false) {
        print("Android notifications permission not granted.");
        return await androidImplementation?.requestNotificationsPermission() ?? false;
      }
      return granted ?? true;
    }
    return false;
  }

  /// Notification Details
  // -> prayer notification details
  NotificationDetails _prayerNotificationDetails() {
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'prayer_channel_id', 'أوقات الصلاة',
      channelDescription: 'إشعارات أوقات الصلاة اليومية',
      importance: Importance.max,
      priority: Priority.high,
      sound: _isCustomSoundAvailable ? const RawResourceAndroidNotificationSound('prayer') : null,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
    );

    final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      sound: _isCustomSoundAvailable ? 'prayer.caf' : null,
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
  }

  // -> repeating notification details (Prophet Reminder)
  NotificationDetails _repeatingNotificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'repeating_channel_id', 'تذكير الصلاة على النبي',
      channelDescription: 'إشعارات الصلاة على النبي كل ساعة',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('say'),
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
      sound: 'say.caf',
    );

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
  }

  // -> Surah Al-Kahf notification details
  NotificationDetails _kahfNotificationDetails() {
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'kahf_channel_id',
      'سورة الكهف',
      channelDescription: 'تذكير بقراءة سورة الكهف يوم الجمعة',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: _isCustomSoundAvailable ? const RawResourceAndroidNotificationSound('note') : null,
    );

    final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: _isCustomSoundAvailable ? 'note.caf' : null,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
  }

  // -> Morning Adhkar notification details
  NotificationDetails _morningAdhkarNotificationDetails() {
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'morning_adhkar_channel_id',
      'أذكار الصباح',
      channelDescription: 'تذكير بأذكار الصباح',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: _isCustomSoundAvailable ? const RawResourceAndroidNotificationSound('morning') : null,
    );

    final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: _isCustomSoundAvailable ? 'morning.caf' : null,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
  }

  // -> Evening Adhkar notification details
  NotificationDetails _eveningAdhkarNotificationDetails() {
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'evening_adhkar_channel_id',
      'أذكار المساء',
      channelDescription: 'تذكير بأذكار المساء',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: _isCustomSoundAvailable ? const RawResourceAndroidNotificationSound('night') : null,
    );

    final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: _isCustomSoundAvailable ? 'night.caf' : null,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
  }

  /// Schedule daily notification for prayer timer
  Future<void> scheduleDailyPrayersNotification(Map<String, String> prayerTimes) async {
    if (!_isInitialized) {
      print('Notification service not initialized.');
      return;
    }
    await cancelAllPrayerNotifications();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print('Current time in local timezone (${tz.local}): $now');

    const Map<String, String> prayerNameArabic = {
      'fajr': 'الفجر',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
      'shuruq': 'الشروق',
      'الفجر': 'الفجر',
      'الظهر': 'الظهر',
      'العصر': 'العصر',
      'المغرب': 'المغرب',
      'العشاء': 'العشاء',
      'الشروق': 'الشروق',
    };

    for (final entry in prayerTimes.entries) {
      final prayerKey = entry.key;
      final timeString = entry.value;

      final String prayerNameDisplay = prayerNameArabic[prayerKey.toLowerCase()] ?? prayerKey;

      try {
        final timeParts = timeString.split(':');
        if (timeParts.length != 2) throw FormatException('Invalid time format for $prayerKey: $timeString');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        tz.TZDateTime scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        final int notificationId = _getPrayerId(prayerKey);

        final String title = 'حان الآن موعد آذان $prayerNameDisplay';
        final String body = 'لا تنس ذكر الله. تقبل الله طاعتكم.';

        print('Scheduling $prayerNameDisplay at $scheduledDate (ID: $notificationId)');

        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            title,
            body,
            scheduledDate,
            _prayerNotificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: 'prayer_$prayerKey',
          );
        } catch (e) {
          print('Error in zonedSchedule for $prayerNameDisplay: $e');
          print('Attempting to schedule without custom sound...');

          final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
            'prayer_channel_id', 'أوقات الصلاة',
            channelDescription: 'إشعارات أوقات الصلاة اليومية',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          );

          final NotificationDetails fallbackDetails = NotificationDetails(
            android: androidDetails,
            iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
          );

          try {
            await _flutterLocalNotificationsPlugin.zonedSchedule(
              notificationId,
              title,
              body,
              scheduledDate,
              fallbackDetails,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              matchDateTimeComponents: DateTimeComponents.time,
              payload: 'prayer_$prayerKey',
            );
            print('Successfully scheduled $prayerNameDisplay notification with default sound');
          } catch (fallbackError) {
            print('Failed to schedule even with default sound: $fallbackError');
          }
        }
      } catch (e, s) {
        print('Error scheduling $prayerNameDisplay notification: $e\n$s');
      }
    }
    print('Finished scheduling daily prayer notifications.');
  }

  /// Schedule hourly repeating notification for Prophet reminder
  Future<void> scheduleHourlyProphetReminder() async {
    if (!_isInitialized) {
      print('Notification service not initialized.');
      return;
    }
    await cancelRepeatingNotification();

    const int notificationId = 99;
    const String title = 'صلي على محمد ﷺ';
    const String body = 'اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ على نَبِيِّنَا مُحمَّد.';

    print('Scheduling hourly reminder (ID: $notificationId)');

    try {
      await _flutterLocalNotificationsPlugin.periodicallyShow(
        notificationId,
        title,
        body,
        RepeatInterval.hourly,
        _repeatingNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'repeating_prophet_reminder',
      );
      print('Hourly reminder scheduled successfully');
    } catch (e) {
      print('Error scheduling hourly reminder: $e');
      print('Failed to schedule hourly reminder.');
    }
  }

  /// Schedule Surah Al-Kahf notification for Friday at 10:00 AM
  Future<void> scheduleSurahKahfNotification() async {
    if (!_isInitialized) {
      print('Notification service not initialized.');
      return;
    }
    await cancelSurahKahfNotification();

    const int notificationId = 100;
    const String title = 'تذكير يوم الجمعة';
    const String body = 'لا تنس قراءة سورة الكهف.';

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10,
      0,
    );

    while (scheduledDate.weekday != DateTime.friday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('Scheduling Surah Al-Kahf at $scheduledDate (ID: $notificationId)');

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        _kahfNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'surah_kahf_reminder',
      );
      print('Surah Al-Kahf reminder scheduled successfully');
    } catch (e) {
      print('Error scheduling Surah Al-Kahf reminder: $e');
    }
  }

  /// Schedule Morning Adhkar notification
  Future<void> scheduleMorningAdhkarNotification(String fajrTime) async {
    if (!_isInitialized) {
      print('Notification service not initialized.');
      return;
    }
    await cancelMorningAdhkarNotification();

    const int notificationId = 101;
    const String title = 'أذكار الصباح';
    const String body = 'لا تنسى قراءة أذكار الصباح،';

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    try {
      final timeParts = fajrTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).add(const Duration(minutes: 30));

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      print('Scheduling Morning Adhkar at $scheduledDate (ID: $notificationId)');

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        _morningAdhkarNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'morning_adhkar_reminder',
      );
      print('Morning Adhkar reminder scheduled successfully');
    } catch (e) {
      print('Error scheduling Morning Adhkar reminder: $e');
    }
  }

  /// Schedule Evening Adhkar notification
  Future<void> scheduleEveningAdhkarNotification(String maghribTime) async {
    if (!_isInitialized) {
      print('Notification service not initialized.');
      return;
    }
    await cancelEveningAdhkarNotification();

    const int notificationId = 102;
    const String title = 'أذكار المساء';
    const String body = 'لا تنسى قراءة أذكار المساء.';

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    try {
      final timeParts = maghribTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).subtract(const Duration(hours: 1));

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      print('Scheduling Evening Adhkar at $scheduledDate (ID: $notificationId)');

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        _eveningAdhkarNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'evening_adhkar_reminder',
      );
      print('Evening Adhkar reminder scheduled successfully');
    } catch (e) {
      print('Error scheduling Evening Adhkar reminder: $e');
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('Cancelled all notifications.');
  }

  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    print('Cancelled notification with ID: $id');
  }

  /// Cancel all scheduled prayer notifications
  Future<void> cancelAllPrayerNotifications() async {
    for (int i = 1; i <= 6; i++) {
      await _flutterLocalNotificationsPlugin.cancel(i);
    }
    print('Cancelled all prayer notifications.');
  }

  /// Cancel repeating notification (Prophet Reminder)
  Future<void> cancelRepeatingNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(99);
    print('Cancelled repeating Prophet reminder notification.');
  }

  /// Cancel Surah Al-Kahf notification
  Future<void> cancelSurahKahfNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(100);
    print('Cancelled Surah Al-Kahf notification.');
  }

  /// Cancel Morning Adhkar notification
  Future<void> cancelMorningAdhkarNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(101);
    print('Cancelled Morning Adhkar notification.');
  }

  /// Cancel Evening Adhkar notification
  Future<void> cancelEveningAdhkarNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(102);
    print('Cancelled Evening Adhkar notification.');
  }

  /// Get unique ID for each prayer
  int _getPrayerId(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return 1;
      case 'dhuhr':
        return 2;
      case 'asr':
        return 3;
      case 'maghrib':
        return 4;
      case 'isha':
        return 5;
      case 'shuruq':
        return 6;
      default:
        return 0;
    }
  }

  // Handle notification tap
  void _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore_for_file: avoid_print
  print('notificationTapBackground: ${notificationResponse.payload}');
}
