part of 'app_cubit.dart';

class AppState extends Equatable {
  final String languageCode;
  final int themeCurrentIndex;


  const AppState({
    this.languageCode = 'ar', // u can change it to 'eg' if ur app will work it by default
    this.themeCurrentIndex = 0,
  });

  @override
  List<Object> get props => [
    languageCode,
    themeCurrentIndex,
  ];

  AppState copyWith({
    String? languageCode,
    int? themeCurrentIndex,
  }) {
    return AppState(
      languageCode: languageCode ?? this.languageCode,
      themeCurrentIndex: themeCurrentIndex ?? this.themeCurrentIndex,
    );
  }
}