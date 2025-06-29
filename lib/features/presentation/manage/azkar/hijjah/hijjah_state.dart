part of 'hijjah_bloc.dart';

@immutable
sealed class HijjahState {}

final class HijjahInitial extends HijjahState {}

class HijjahLoading extends HijjahState {}

class HijjahLoaded extends HijjahState {
  final List<HijjahModel> azkarData;

  HijjahLoaded(this.azkarData);
}

class HijjahError extends HijjahState {
  final String message;

  HijjahError(this.message);
}
