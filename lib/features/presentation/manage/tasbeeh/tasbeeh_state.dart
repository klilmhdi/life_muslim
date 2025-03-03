part of 'tasbeeh_cubit.dart';

class TasbeehState {
  final List<String> tasbeehList;
  final String selectedTasbeeh;
  final int counter;

  TasbeehState({
    required this.tasbeehList,
    required this.selectedTasbeeh,
    required this.counter,
  });

  factory TasbeehState.initial() {
    return TasbeehState(
      tasbeehList: [
        "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
        "لَا إلَه إلّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلُّ شَيْءِ قَدِيرِ",
        "لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ",
        "الْلَّهُم صَلِّ وَسَلِم وَبَارِك عَلَى سَيِّدِنَا مُحَمَّد",
        "سُبْحَانَ الْلَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا الْلَّهُ، وَالْلَّهُ أَكْبَرُ",
        "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ , وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ , اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ",
      ],
      selectedTasbeeh: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
      counter: 0,
    );
  }

  TasbeehState copyWith({
    List<String>? tasbeehList,
    String? selectedTasbeeh,
    int? counter,
  }) {
    return TasbeehState(
      tasbeehList: tasbeehList ?? this.tasbeehList,
      selectedTasbeeh: selectedTasbeeh ?? this.selectedTasbeeh,
      counter: counter ?? this.counter,
    );
  }
}