part of 'azkar_bloc.dart';

@immutable
sealed class AzkarState {}

final class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarLoaded extends AzkarState {
  final List<AzkarModel> azkarData;

  AzkarLoaded(this.azkarData);
}

class AzkarError extends AzkarState {
  final String message;

  AzkarError(this.message);
}
