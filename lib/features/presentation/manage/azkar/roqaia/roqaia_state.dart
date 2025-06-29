part of 'roqaia_bloc.dart';

@immutable
sealed class RoqaiaState {}

final class RoqaiaInitial extends RoqaiaState {}

class RoqaiaLoading extends RoqaiaState {}

class RoqaiaLoaded extends RoqaiaState {
  final List<RoqaiaModel> azkarData;

  RoqaiaLoaded(this.azkarData);
}

class RoqaiaError extends RoqaiaState {
  final String message;

  RoqaiaError(this.message);
}
