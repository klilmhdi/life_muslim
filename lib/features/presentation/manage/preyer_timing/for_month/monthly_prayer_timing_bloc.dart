import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_life_muslim/features/data/repository/prayer_timing_repo.dart';
import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';

import '../../../../data/models/adhan/azan_by_month_model.dart';

part 'monthly_prayer_timing_event.dart';
part 'monthly_prayer_timing_state.dart';

class MonthlyPrayerTimingBloc extends Bloc<MonthlyPrayerTimingEvent, MonthlyPrayerTimingState> {
  final LocationBloc _locationBloc;

  MonthlyPrayerTimingBloc(this._locationBloc) : super(MonthlyPrayerTimingInitial()) {
    on<FetchPrayerTimes>(_onFetchMonthlyPrayerTiming);
    _locationBloc.stream.listen((locationState) {
      if (locationState is LocationSaved) {
        add(FetchPrayerTimes(
            lat: locationState.latitude,
            long: locationState.longitude,
            month: DateTime.now().month,
            year: DateTime.now().year));
      }
    });
  }

  Future<void> _onFetchMonthlyPrayerTiming(
    FetchPrayerTimes event,
    Emitter<MonthlyPrayerTimingState> emit,
  ) async {
    emit(MonthlyPrayerTimesLoading());

    try {
      final lat = event.lat;
      final long = event.long;

      final data = await PrayerTimingsRepository().getMonthlyPrayerTimings(
        lat: lat,
        long: long,
        month: event.month,
        year: event.year,
      );
      print("...... Fetched Successful");
      emit(MonthlyPrayerTimesLoaded(data));
    } catch (e, s) {
      print("...... Error: $e");
      print("...... StackTrace: $s");
      emit(MonthlyPrayerTimesError("حدث خطأ أثناء تحميل البيانات"));
    }
  }
}
