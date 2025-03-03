import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';

part 'tasbeeh_state.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  TasbeehCubit() : super(TasbeehState.initial());

  // تحميل العداد من SharedPreferences
  Future<void> loadCounter() async {
    final counter = await SharedPrefController.getTasbeehCounter(state.selectedTasbeeh);
    emit(state.copyWith(counter: counter)); // تحديث الحالة بالقيمة المحملة
  }

  // تغيير التسبيح المحدد
  Future<void> selectTasbeeh(String tasbeeh) async {
    final counter = await SharedPrefController.getTasbeehCounter(tasbeeh);
    emit(state.copyWith(selectedTasbeeh: tasbeeh, counter: counter));
  }

  // زيادة العداد وحفظه
  Future<void> incrementCounter() async {
    final newCounter = state.counter + 1;
    await SharedPrefController.saveTasbeehCounter(state.selectedTasbeeh, newCounter); // حفظ القيمة الجديدة
    emit(state.copyWith(counter: newCounter)); // تحديث الحالة
  }

  // إعادة تعيين العداد وحفظه
  Future<void> resetCounter() async {
    await SharedPrefController.saveTasbeehCounter(state.selectedTasbeeh, 0); // حفظ القيمة الجديدة
    emit(state.copyWith(counter: 0)); // تحديث الحالة
  }

  // حذف العداد
  Future<void> deleteCounter() async {
    await SharedPrefController.deleteTasbeehCounter(state.selectedTasbeeh); // حذف القيمة
    emit(state.copyWith(counter: 0)); // تحديث الحالة
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart'; // استيراد SharedPrefController
//
// part 'tasbeeh_state.dart';
//
// class TasbeehCubit extends Cubit<int> {
//   TasbeehCubit() : super(0);
//
//   // تحميل العداد من SharedPreferences
//   Future<void> loadCounter() async {
//     final counter = await SharedPrefController.getTasbeehCounter();
//     emit(counter); // تحديث الحالة بالقيمة المحملة
//   }
//
//   // زيادة العداد وحفظه
//   Future<void> incrementCounter() async {
//     final newCounter = state + 1;
//     await SharedPrefController.saveTasbeehCounter(newCounter); // حفظ القيمة الجديدة
//     emit(newCounter); // تحديث الحالة
//   }
//
//   // إعادة تعيين العداد وحفظه
//   Future<void> resetCounter() async {
//     await SharedPrefController.saveTasbeehCounter(0); // حفظ القيمة الجديدة
//     emit(0); // تحديث الحالة
//   }
//
//   // حذف العداد
//   Future<void> deleteCounter() async {
//     await SharedPrefController.deleteTasbeehCounter(); // حذف القيمة
//     emit(0); // تحديث الحالة
//   }
// }