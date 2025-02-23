import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart'; // استيراد SharedPrefController

class TasbeehCubit extends Cubit<int> {
  TasbeehCubit() : super(0);

  // تحميل العداد من SharedPreferences
  Future<void> loadCounter() async {
    final counter = await SharedPrefController.getTasbeehCounter();
    emit(counter); // تحديث الحالة بالقيمة المحملة
  }

  // زيادة العداد وحفظه
  Future<void> incrementCounter() async {
    final newCounter = state + 1;
    await SharedPrefController.saveTasbeehCounter(newCounter); // حفظ القيمة الجديدة
    emit(newCounter); // تحديث الحالة
  }

  // إعادة تعيين العداد وحفظه
  Future<void> resetCounter() async {
    await SharedPrefController.saveTasbeehCounter(0); // حفظ القيمة الجديدة
    emit(0); // تحديث الحالة
  }

  // حذف العداد
  Future<void> deleteCounter() async {
    await SharedPrefController.deleteTasbeehCounter(); // حذف القيمة
    emit(0); // تحديث الحالة
  }
}