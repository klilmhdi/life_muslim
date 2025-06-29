part of 'monthly_prayer_timing_bloc.dart';

abstract class MonthlyPrayerTimingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonthlyPrayerTimingInitial extends MonthlyPrayerTimingState {}

class MonthlyPrayerTimesLoading extends MonthlyPrayerTimingState {}

class MonthlyPrayerTimesLoaded extends MonthlyPrayerTimingState {
  final MontlyPrayerTimingsModel prayerTimings;
  // final List<MontlyPrayerTimingsModel> prayerTimings;

  MonthlyPrayerTimesLoaded(this.prayerTimings);

  @override
  List<Object?> get props => [prayerTimings];
}

class MonthlyPrayerTimesError extends MonthlyPrayerTimingState {
  final String message;

  MonthlyPrayerTimesError(this.message);

  @override
  List<Object?> get props => [message];
}