import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/screens/adhan/adhan_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/azkar/azkar_details_screen.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

import '../../manage/azkar/azkar_bloc.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "أدعية وأذكار", isLeading: false),
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => AzkarBloc()..add(LoadAzkar()),
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.fourthBackgroundImage),
                  fit: BoxFit.cover,
                  opacity: 0.3)),
          child: BlocBuilder<AzkarBloc, AzkarState>(
            builder: (context, state) {
              if (state is AzkarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AzkarError) {
                return Center(child: Text(state.message));
              } else if (state is AzkarLoaded) {
                return SafeArea(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: state.azkarData.length,
                    itemBuilder: (context, index) {
                      final azkarCategory = state.azkarData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdhkarDetailsScreen(
                                adhkar: azkarCategory.array!,
                                title: azkarCategory.category ?? "",
                              ),
                            ),
                          );
                        },
                        child: Card(
                          surfaceTintColor: Colors.deepPurple,
                          elevation: 5,
                          color: Colors.white.withOpacity(0.01),
                          // shadowColor: Colors.deepPurple.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.menu_book, size: 40.sp),
                                const SizedBox(height: 10),
                                Text(
                                  azkarCategory.category ?? "بدون عنوان",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "عدد الأذكار: (${azkarCategory.array?.length ?? 0})",
                                  style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade50),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: Text("لا توجد بيانات متاحة"));
            },
          ),
        ),
      ),
    );
  }
}
