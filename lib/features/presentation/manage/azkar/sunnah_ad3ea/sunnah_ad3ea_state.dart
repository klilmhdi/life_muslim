part of 'sunnah_ad3ea_bloc.dart';

@immutable
sealed class SunnahAzkarState {}

final class SunnahAzkarInitial extends SunnahAzkarState {}

class SunnahAzkarLoading extends SunnahAzkarState {}

class SunnahAzkarLoaded extends SunnahAzkarState {
  final List<SunnahAzkarModel> azkarData;

  SunnahAzkarLoaded(this.azkarData);
}

class SunnahAzkarError extends SunnahAzkarState {
  final String message;

  SunnahAzkarError(this.message);
}
