part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class EnablePrayerNotifications extends NotificationEvent {
  final Map<String, String> prayerTimes;
  final TodayPrayerTimingsModel? timingsModel;

  const EnablePrayerNotifications(this.prayerTimes, {this.timingsModel});

  @override
  List<Object> get props => [prayerTimes, timingsModel ?? ''];
}

class DisablePrayerNotifications extends NotificationEvent {}