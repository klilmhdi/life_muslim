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
import 'package:quran_life_muslim/core/utils/notification/local_notification_service.dart';
import 'package:quran_life_muslim/core/utils/style/app_style.dart';
import 'package:quran_life_muslim/features/data/repository/prayer_timing_repo.dart';
import 'package:quran_life_muslim/features/presentation/manage/azkar/quran_ad3ea/quran_ad3ea_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/bookmark/bookmark_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/change_ayah_display/change_ayah_display_cubit.dart';
import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/for_month/monthly_prayer_timing_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';
import 'package:quran_life_muslim/features/presentation/manage/quran/quran_bloc.dart';
import 'package:quran_life_muslim/features/presentation/screens/getstarted/getstarted_screen.dart';
import 'package:quran_life_muslim/features/presentation/screens/layout/layout.dart';
import 'package:quran_life_muslim/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/enums/pr_keys_enum.dart';
import 'features/presentation/manage/azkar/general_azkar/azkar_bloc.dart';
import 'features/presentation/manage/azkar/hijjah/hijjah_bloc.dart';
import 'features/presentation/manage/azkar/name_of_allah/name_of_allah_bloc.dart';
import 'features/presentation/manage/azkar/nawawi/nawawi_bloc.dart';
import 'features/presentation/manage/azkar/roqaia/roqaia_bloc.dart';
import 'features/presentation/manage/azkar/sunnah_ad3ea/sunnah_ad3ea_bloc.dart';
import 'features/presentation/manage/notification/notification_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().initializeNotification();
  // await RemoteNotificationService.init();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/tajawal.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await SharedPrefController().initPreferences();
  await SharedPreferences.getInstance();

  Bloc.observer = MyBlocObserver();

  final bool isFirstLaunch = SharedPrefController().getValueFor<bool>(PrKeys.isFirstLaunch.name) ?? false;

  runApp(MyApp(showGetStarted: !isFirstLaunch));
}

class MyApp extends StatefulWidget {
  final bool showGetStarted;

  const MyApp({super.key, required this.showGetStarted});

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
      builder: (BuildContext context, Widget? child) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => PrayerTimingsRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => QuranBloc()..add(LoadQuran())),
            BlocProvider(create: (context) => QuranAzkarBloc()..add(LoadQuranAzkar())),
            BlocProvider(create: (context) => SunnahAzkarBloc()..add(LoadSunnahAzkar())),
            BlocProvider(create: (context) => RoqaiaBloc()..add(LoadRoqaia())),
            BlocProvider(create: (context) => NawawiBloc()..add(LoadNawawi())),
            BlocProvider(create: (context) => HijjahBloc()..add(LoadHijjah())),
            BlocProvider(create: (context) => NameOfAllahBloc()..add(LoadNameOfAllah())),
            BlocProvider(create: (context) => AzkarBloc()..add(LoadAzkar())),
            BlocProvider(create: (context) => BookmarkBloc()..add(GetBookmarks())),
            BlocProvider(
              create: (context) => PrayerTimingsBloc(
                repository: context.read<PrayerTimingsRepository>(),
                notificationService: LocalNotificationService(),
                sharedPrefController: SharedPrefController(),
              ),
            ),
            BlocProvider(create: (context) => LocationBloc()),
            BlocProvider(create: (_) => NotificationBloc(LocalNotificationService())),
            BlocProvider(create: (context) => MonthlyPrayerTimingBloc(LocationBloc())),
            BlocProvider<AppCubit>(create: (context) => AppCubit()..setLanguage(languageCode: null)),
            BlocProvider<ChangeAyahDisplayCubit>(create: (context) => ChangeAyahDisplayCubit()),
          ],
          child: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) => MaterialApp(
              title: 'حياة المسلم',
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
              debugShowCheckedModeBanner: false,
              home: widget.showGetStarted
                  ? GetstartedScreen(
                      onFinished: () async {
                        debugPrint("-------------- Pressed!");
                        await SharedPrefController().setBool(key: PrKeys.isFirstLaunch.name, value: true);
                        if (mounted) setState(() {});
                      },
                    )
                  : const Layout(),
            ),
          ),
        ),
      ),
    );
  }
}
