part of 'quran_ad3ea_bloc.dart';

@immutable
sealed class QuranAzkarState {}

final class QuranAzkarInitial extends QuranAzkarState {}

class QuranAzkarLoading extends QuranAzkarState {}

class QuranAzkarLoaded extends QuranAzkarState {
  final List<QuranAzkarModel> azkarData;

  QuranAzkarLoaded(this.azkarData);
}

class QuranAzkarError extends QuranAzkarState {
  final String message;

  QuranAzkarError(this.message);
}
