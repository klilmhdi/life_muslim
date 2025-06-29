part of 'change_ayah_display_cubit.dart';

enum AyahDisplayMode { scroll, page }

class ChangeAyahDisplayState {
  final AyahDisplayMode displayMode;

  ChangeAyahDisplayState({required this.displayMode});

  Map<String, dynamic> toMap() => {'displayMode': displayMode.index};

  factory ChangeAyahDisplayState.fromMap(Map<String, dynamic> map) => ChangeAyahDisplayState(
        displayMode: AyahDisplayMode.values[map['displayMode'] ?? 0],
      );
}
