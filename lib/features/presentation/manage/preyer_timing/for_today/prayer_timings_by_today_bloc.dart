import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart'; // Import SharedPrefController
import 'package:quran_life_muslim/core/utils/notification/local_notification_service.dart'; // Use the updated service
import 'package:quran_life_muslim/features/data/models/adhan/azan_by_current_timer_model.dart';
import 'package:quran_life_muslim/features/data/repository/prayer_timing_repo.dart';

part 'prayer_timings_by_today_event.dart';
part 'prayer_timings_by_today_state.dart';

class PrayerTimingsBloc extends Bloc<PrayerTimingsEvent, PrayerTimingsState> {
  final PrayerTimingsRepository _repository;
  final LocalNotificationService _notificationService;
  final SharedPrefController _sharedPrefController;

  PrayerTimingsBloc({
    required PrayerTimingsRepository repository,
    required LocalNotificationService notificationService,
    required SharedPrefController sharedPrefController,
  })  : _repository = repository,
        _notificationService = notificationService,
        _sharedPrefController = sharedPrefController,
        super(PrayerTimingsInitial()) {
    on<FetchPrayerTimings>(_onFetchPrayerTimings);
    on<ScheduleNotificationsIfEnabled>(_onScheduleNotificationsIfEnabled);
    on<DisablePrayerNotifications>(_onDisableNotifications);
  }

  Future<void> _onFetchPrayerTimings(
    FetchPrayerTimings event,
    Emitter<PrayerTimingsState> emit,
  ) async {
    emit(PrayerTimingsLoading());

    try {
      final timings = await _repository.getTodayPrayerTimings(latitude: event.latitude, longitude: event.longitude);
      emit(PrayerTimingsLoaded(timings, notificationsEnabled: await _sharedPrefController.getNotificationsEnabled()));
      add(ScheduleNotificationsIfEnabled(timings.toTimeMap(), timingsModel: timings)); // Pass timingsModel
    } catch (e, s) {
      emit(PrayerTimingsError('حدث خطأ أثناء جلب أوقات الصلاة: $e'));
      debugPrint('Error fetching prayer timings: $e');
      debugPrint('Stack trace: $s');
    }
  }

  Future<void> _onScheduleNotificationsIfEnabled(
    ScheduleNotificationsIfEnabled event,
    Emitter<PrayerTimingsState> emit,
  ) async {
    try {
      final bool areNotificationsEnabled = await _sharedPrefController.getNotificationsEnabled();

      if (areNotificationsEnabled) {
        debugPrint('Notifications are enabled, scheduling...');
        await _notificationService.initializeNotification();
        bool permissionsGranted = await _notificationService.requestPermissions();

        if (permissionsGranted) {
          debugPrint('Permissions granted. Scheduling daily and hourly notifications.');
          // Using the prayerTimes passed with the event
          await _notificationService.scheduleDailyPrayersNotification(event.prayerTimes);
          await _notificationService.scheduleHourlyProphetReminder();
          await _notificationService.scheduleSurahKahfNotification();
          if (event.timingsModel != null) {
            await _notificationService.scheduleMorningAdhkarNotification(event.timingsModel!.fajr);
            await _notificationService.scheduleEveningAdhkarNotification(event.timingsModel!.maghrib);
          }
          if (state is PrayerTimingsLoaded) {
            emit((state as PrayerTimingsLoaded).copyWith(notificationsEnabled: true));
          }
        } else {
          debugPrint('Permissions not granted. Cannot schedule notifications.');
          if (state is PrayerTimingsLoaded) {
            emit((state as PrayerTimingsLoaded).copyWith(notificationsEnabled: false));
          }
        }
      } else {
        debugPrint('Notifications are disabled in preferences. Skipping scheduling.');
        await _notificationService.cancelAllPrayerNotifications();
        await _notificationService.cancelRepeatingNotification();
        await _notificationService.cancelSurahKahfNotification();
        await _notificationService.cancelMorningAdhkarNotification();
        await _notificationService.cancelEveningAdhkarNotification();
        if (state is PrayerTimingsLoaded) {
          emit((state as PrayerTimingsLoaded).copyWith(notificationsEnabled: false));
        }
      }
    } catch (e, s) {
      debugPrint('Error in _onScheduleNotificationsIfEnabled: $e\n$s');
    }
  }

  Future<void> _onDisableNotifications(
    DisablePrayerNotifications event,
    Emitter<PrayerTimingsState> emit,
  ) async {
    try {
      debugPrint('Disabling notifications...');
      await _sharedPrefController.setNotificationsEnabled(false);
      await _notificationService.cancelAllPrayerNotifications();
      await _notificationService.cancelRepeatingNotification();
      await _notificationService.cancelSurahKahfNotification();
      await _notificationService.cancelMorningAdhkarNotification();
      await _notificationService.cancelEveningAdhkarNotification();
      if (state is PrayerTimingsLoaded) {
        emit((state as PrayerTimingsLoaded).copyWith(notificationsEnabled: false));
      } else {
        // If state is not loaded, perhaps just ensure prefs are set
      }
      debugPrint('Notifications disabled and cancelled.');
    } catch (e, s) {
      debugPrint('Error disabling notifications: $e\n$s');
      emit(PrayerTimingsError('فشل في تعطيل الإشعارات: $e'));
    }
  }
}

// Extension remains the same
extension PrayerTimingsExtensions on TodayPrayerTimingsModel {
  Map<String, String> toTimeMap() {
    return {
      'Fajr': fajr,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
      // Add Shuruq if needed
    };
  }
}