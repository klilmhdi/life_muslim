part of 'quran_bloc.dart';

abstract class QuranState {}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class QuranLoaded extends QuranState {
  final QuranModel quranData;

  QuranLoaded(this.quranData);
}

class QuranError extends QuranState {
  final String message;

  QuranError(this.message);
}
