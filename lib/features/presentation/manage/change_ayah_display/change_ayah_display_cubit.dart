import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'change_ayah_display_state.dart';

class ChangeAyahDisplayCubit extends Cubit<ChangeAyahDisplayState> {
  ChangeAyahDisplayCubit() : super(ChangeAyahDisplayState(displayMode: AyahDisplayMode.page));

  void updateDisplayMode(AyahDisplayMode mode) => emit(ChangeAyahDisplayState(displayMode: mode));

  ChangeAyahDisplayState fromJson(Map<String, dynamic> json) => ChangeAyahDisplayState.fromMap(json);

  Map<String, dynamic> toJson(ChangeAyahDisplayState state) => state.toMap();
}
