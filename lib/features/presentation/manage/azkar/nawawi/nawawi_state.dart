part of 'nawawi_bloc.dart';

@immutable
sealed class NawawiState {}

final class NawawiInitial extends NawawiState {}

class NawawiLoading extends NawawiState {}

class NawawiLoaded extends NawawiState {
  final List<NawawiModel> azkarData;

  NawawiLoaded(this.azkarData);
}

class NawawiError extends NawawiState {
  final String message;

  NawawiError(this.message);
}
