import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
import 'package:quran_life_muslim/core/bloc_observer.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/notification/notification_service.dart';
import 'package:quran_life_muslim/core/utils/style/app_style.dart';
import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/prayer_timings_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/quran/quran_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/getstarted/getstarted_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/layout/layout.dart';
import 'package:quran_life_muslim/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // تهيئة الإشعارات

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/tajawal.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await SharedPrefController().initPreferences();
  await SharedPreferences.getInstance();

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => QuranBloc()..add(LoadQuran())),
          BlocProvider(create: (context) => PrayerTimingsBloc()),
          BlocProvider<AppCubit>(create: (context) => AppCubit()..setLanguage(languageCode: null)),
        ],
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => MaterialApp(
            title: 'Quran Life Muslim',
            theme: AppStyle(themeIndex: state.themeCurrentIndex).currentTheme,
            themeMode: ThemeMode.light,
            locale: Locale(state.languageCode),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: const GetstartedScreen(),
          ),
        ),
      ),
    );
  }
}
