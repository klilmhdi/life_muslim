part of 'name_of_allah_bloc.dart';

@immutable
sealed class NameOfAllahState {}

final class NameOfAllahInitial extends NameOfAllahState {}

class NameOfAllahLoading extends NameOfAllahState {}

class NameOfAllahLoaded extends NameOfAllahState {
  final List<NameOfAllahModel> azkarData;

  NameOfAllahLoaded(this.azkarData);
}

class NameOfAllahError extends NameOfAllahState {
  final String message;

  NameOfAllahError(this.message);
}
