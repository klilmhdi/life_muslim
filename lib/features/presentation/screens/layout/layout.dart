import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_services_cards_widget.dart';

import '../../../../core/enums/message_type.dart';
import '../../../../core/utils/assets/assets.dart';
import '../../manage/location/location_bloc.dart';
import '../../manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';
import '../../widgets/custom_appbar/build_appbar.dart';
import '../../widgets/custom_card/build_intro_card_widget.dart';
import '../../widgets/custom_card/build_stop_card_widget.dart';
import '../../widgets/custom_dialog/custom_dialog_widget.dart';
import '../../widgets/custom_menu/drawer_widget.dart';
import '../../widgets/custom_snack_bar/snackbar_widget.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  void initState() {
    super.initState();
    // context.read<LocationBloc>().add(LoadLocationEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowNotificationDialog());
  }

  Future<void> _checkAndShowNotificationDialog() async {
    if (!mounted) return;

    final prefController = SharedPrefController();
    await prefController.initPreferences();
    final dialogShown = await prefController.isNotificationsDialogShown();

    if (!dialogShown) {
      await NotificationDialog.showNotificationDialog(
          context: context, sharedPrefController: prefController, prayerTimingsBloc: context.read<PrayerTimingsBloc>());
    } else {
      print("Notification dialog already shown. Bloc will handle scheduling if enabled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationPermissionDenied) {
          NotificationDialog.showLocationPermissionDialog(context,
              reloadPage: () => context.read<LocationBloc>().add(RequestLocationPermissionEvent()));
        } else if (state is LocationPermissionPermanentlyDenied) {
          showCustomSnackBar(context: context, title: state.message, duration: 2, type: MessageType.error);
        } else if (state is LocationServiceDisabled) {
          showCustomSnackBar(context: context, title: state.message, duration: 2, type: MessageType.info);
        } else if (state is LocationSaved) {
          debugPrint("Location loaded: ${state.latitude}, ${state.longitude}. Fetching prayer times.");
          context.read<PrayerTimingsBloc>().add(FetchPrayerTimings(latitude: state.latitude, longitude: state.longitude));
        } else if (state is LocationHasSavedData) {
          debugPrint("Location has already saved: ${state.locationData["latitude"]}, ${state.locationData["longitude"]}. Fetching prayer times.");
          context.read<PrayerTimingsBloc>().add(FetchPrayerTimings(latitude: state.locationData["latitude"], longitude: state.locationData["longitude"]));
        }
      },
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, appState) {
          final color = appState.themeCurrentIndex == 0 ? AppConsts.secondaryDarkAppColor : AppConsts.basicDarkAppColor;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: buildAppBar(
              context,
              title: "حياة المسلم",
              color: Colors.white,
              isLeading: true,
            ),
            drawer: customDrawer(context),
            body: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(AppAssets.thirdBackgroundImage),
                  fit: BoxFit.cover,
                  opacity: 0.2,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      final isPortrait = orientation == Orientation.portrait;
                      final screenHeight = constraints.maxHeight;

                      return SingleChildScrollView(
                        physics: isPortrait ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: screenHeight),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: isPortrait ? screenHeight * 0.34 : screenHeight * 0.42,
                                child: BlocBuilder<LocationBloc, LocationState>(
                                  builder: (context, locationState) =>
                                      BlocBuilder<PrayerTimingsBloc, PrayerTimingsState>(
                                    builder: (context, prayerState) => IntroCardWidget(
                                      condition: color,
                                      isPortrait: isPortrait,
                                    ),
                                  ),
                                ),
                              ),
                              DelayedDisplay(
                                delay: const Duration(milliseconds: 100),
                                child: buildStopCardWidget(context, color: color),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: isPortrait ? 8.0 : 2.0,
                                  horizontal: isPortrait ? 8.0 : 8.0,
                                ),
                                child: BuildServicesCardsWidget(
                                  isPortrait: isPortrait,
                                  isDark: appState.themeCurrentIndex == 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
