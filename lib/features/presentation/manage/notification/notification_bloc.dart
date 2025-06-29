import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/notification/local_notification_service.dart';
import '../../../data/models/adhan/azan_by_current_timer_model.dart'; // Import the model

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final LocalNotificationService _notificationService;

  NotificationBloc(this._notificationService) : super(NotificationInitial()) {
    on<EnablePrayerNotifications>(_onEnablePrayerNotifications);
    on<DisablePrayerNotifications>(_onDisablePrayerNotifications);
  }

  Future<void> _onEnablePrayerNotifications(
      EnablePrayerNotifications event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoading());
    try {
      await _notificationService.initializeNotification();
      await _notificationService.scheduleDailyPrayersNotification(event.prayerTimes);
      await _notificationService.scheduleHourlyProphetReminder();
      await _notificationService.scheduleSurahKahfNotification();
      // Check if timingsModel is available before scheduling Adhkar
      if (event.timingsModel != null) {
        await _notificationService.scheduleMorningAdhkarNotification(event.timingsModel!.fajr);
        await _notificationService.scheduleEveningAdhkarNotification(event.timingsModel!.maghrib);
      }
      emit(NotificationEnabled());
    } catch (e) {
      emit(NotificationError('Failed to enable notifications: $e'));
    }
  }

  Future<void> _onDisablePrayerNotifications(
      DisablePrayerNotifications event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoading());
    try {
      await _notificationService.cancelAllNotifications();
      await _notificationService.cancelSurahKahfNotification();
      await _notificationService.cancelMorningAdhkarNotification();
      await _notificationService.cancelEveningAdhkarNotification();
      emit(NotificationDisabled());
    } catch (e) {
      emit(NotificationError('Failed to disable notifications: $e'));
    }
  }
}