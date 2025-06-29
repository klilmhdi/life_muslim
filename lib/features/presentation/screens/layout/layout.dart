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
    // Fetch location first
    context.read<LocationBloc>().add(LoadLocationEvent());

    // Fetch prayer timings (which will trigger notification scheduling via bloc if enabled)
    // Assuming location data is available or fetched before this widget loads.
    // You might need to listen to LocationBloc state changes to get lat/lon first.
    // For demonstration, assuming lat/lon are fetched elsewhere or default values are used.
    // Example: context.read<PrayerTimingsBloc>().add(FetchPrayerTimings(latitude: 30.0, longitude: 31.0));

    // Show notification dialog after the first frame if needed
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowNotificationDialog());
  }

  Future<void> _checkAndShowNotificationDialog() async {
    // Ensure the context is still mounted before proceeding
    if (!mounted) return;

    final prefController = SharedPrefController(); // Assuming singleton access
    await prefController.initPreferences(); // Ensure prefs are loaded
    final dialogShown = await prefController.isNotificationsDialogShown();

    if (!dialogShown) {
      // Pass the necessary bloc/service instances or rely on context lookup
      await NotificationDialog.showNotificationDialog(
        context: context,
        sharedPrefController: prefController, // Pass controller
        prayerTimingsBloc: context.read<PrayerTimingsBloc>(), // Pass bloc
      );
    } else {
      // If dialog was already shown, the PrayerTimingsBloc's initial fetch
      // should handle scheduling based on saved preferences.
      print("Notification dialog already shown. Bloc will handle scheduling if enabled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationPermissionDenied) {
          // Use the location permission dialog from the updated file if it exists
          // Or keep the original one if it wasn't part of the update request
          NotificationDialog.showLocationPermissionDialog(context, reloadPage: () {
            context.read<LocationBloc>().add(RequestLocationPermissionEvent());
          });
        } else if (state is LocationPermissionPermanentlyDenied) {
          showCustomSnackBar(
            context: context,
            title: state.message,
            duration: 3000, // Increased duration
            type: MessageType.error,
          );
        } else if (state is LocationServiceDisabled) {
          showCustomSnackBar(
            context: context,
            title: state.message,
            duration: 3000, // Increased duration
            type: MessageType.info,
          );
        } else if (state is LocationSaved) {
          // Once location is loaded, fetch prayer times
          print("Location loaded: ${state.latitude}, ${state.longitude}. Fetching prayer times.");
          context
              .read<PrayerTimingsBloc>()
              .add(FetchPrayerTimings(latitude: state.latitude, longitude: state.longitude));
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
                                  // Using PrayerTimingsBloc builder to show timings when loaded
                                  builder: (context, locationState) =>
                                      BlocBuilder<PrayerTimingsBloc, PrayerTimingsState>(
                                    builder: (context, prayerState) => IntroCardWidget(
                                      condition: color,
                                      isPortrait: isPortrait,
                                      // Pass prayer state to IntroCardWidget if needed
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

// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_life_muslim/core/app_cubit/app/app_cubit.dart';
// import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
// import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
// import 'package:quran_life_muslim/features/presentation/widgets/custom_card/build_services_cards_widget.dart';
//
// import '../../../../core/enums/message_type.dart';
// import '../../../../core/utils/assets/assets.dart';
// import '../../manage/location/location_bloc.dart';
// import '../../manage/preyer_timing/for_today/prayer_timings_by_today_bloc.dart';
// import '../../widgets/custom_appbar/build_appbar.dart';
// import '../../widgets/custom_card/build_intro_card_widget.dart';
// import '../../widgets/custom_card/build_stop_card_widget.dart';
// import '../../widgets/custom_dialog/custom_dialog_widget.dart';
// import '../../widgets/custom_menu/drawer_widget.dart';
// import '../../widgets/custom_snack_bar/snackbar_widget.dart';
//
// class Layout extends StatefulWidget {
//   const Layout({super.key});
//
//   @override
//   State<Layout> createState() => _LayoutState();
// }
//
// class _LayoutState extends State<Layout> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch location first
//     context.read<LocationBloc>().add(LoadLocationEvent());
//
//     // Fetch prayer timings (which will trigger notification scheduling via bloc if enabled)
//     // Assuming location data is available or fetched before this widget loads.
//     // You might need to listen to LocationBloc state changes to get lat/lon first.
//     // For demonstration, assuming lat/lon are fetched elsewhere or default values are used.
//     // Example: context.read<PrayerTimingsBloc>().add(FetchPrayerTimings(latitude: 30.0, longitude: 31.0));
//
//     // Show notification dialog after the first frame if needed
//     WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowNotificationDialog());
//   }
//
//   Future<void> _checkAndShowNotificationDialog() async {
//     // Ensure the context is still mounted before proceeding
//     if (!mounted) return;
//
//     final prefController = SharedPrefController(); // Assuming singleton access
//     await prefController.initPreferences(); // Ensure prefs are loaded
//     final dialogShown = await prefController.isNotificationsDialogShown();
//
//     if (!dialogShown) {
//       // Pass the necessary bloc/service instances or rely on context lookup
//       await NotificationDialog.showNotificationDialog(
//         context: context,
//         sharedPrefController: prefController, // Pass controller
//         prayerTimingsBloc: context.read<PrayerTimingsBloc>(), // Pass bloc
//       );
//     } else {
//       // If dialog was already shown, the PrayerTimingsBloc's initial fetch
//       // should handle scheduling based on saved preferences.
//       print("Notification dialog already shown. Bloc will handle scheduling if enabled.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LocationBloc, LocationState>(
//       listener: (context, state) {
//         if (state is LocationPermissionDenied) {
//           // Use the location permission dialog from the updated file if it exists
//           // Or keep the original one if it wasn't part of the update request
//           NotificationDialog.showLocationPermissionDialog(context, reloadPage: () {
//             context.read<LocationBloc>().add(RequestLocationPermissionEvent());
//           });
//         } else if (state is LocationPermissionPermanentlyDenied) {
//           showCustomSnackBar(
//             context: context,
//             title: state.message,
//             duration: 3000, // Increased duration
//             type: MessageType.error,
//           );
//         } else if (state is LocationServiceDisabled) {
//           showCustomSnackBar(
//             context: context,
//             title: state.message,
//             duration: 3000, // Increased duration
//             type: MessageType.info,
//           );
//         } else if (state is LocationSaved) {
//           // Once location is loaded, fetch prayer times
//           print("Location loaded: ${state.latitude}, ${state.longitude}. Fetching prayer times.");
//           context
//               .read<PrayerTimingsBloc>()
//               .add(FetchPrayerTimings(latitude: state.latitude, longitude: state.longitude));
//         }
//       },
//       child: BlocConsumer<AppCubit, AppState>(
//         listener: (context, state) {},
//         builder: (context, appState) {
//           final color = appState.themeCurrentIndex == 0 ? AppConsts.secondaryDarkAppColor : AppConsts.basicDarkAppColor;
//           return Scaffold(
//             extendBodyBehindAppBar: true,
//             appBar: buildAppBar(
//               context,
//               title: "حياة المسلم",
//               color: Colors.white,
//               isLeading: true,
//             ),
//             drawer: customDrawer(context),
//             body: Container(
//               decoration: BoxDecoration(
//                 image: const DecorationImage(
//                   image: AssetImage(AppAssets.thirdBackgroundImage),
//                   fit: BoxFit.cover,
//                   opacity: 0.2,
//                 ),
//               ),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return OrientationBuilder(
//                     builder: (context, orientation) {
//                       final isPortrait = orientation == Orientation.portrait;
//                       final screenHeight = constraints.maxHeight;
//
//                       return SingleChildScrollView(
//                         physics: isPortrait ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(minHeight: screenHeight),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(
//                                 height: isPortrait ? screenHeight * 0.34 : screenHeight * 0.42,
//                                 child: BlocBuilder<LocationBloc, LocationState>(
//                                   // Using PrayerTimingsBloc builder to show timings when loaded
//                                   builder: (context, locationState) =>
//                                       BlocBuilder<PrayerTimingsBloc, PrayerTimingsState>(
//                                     builder: (context, prayerState) => IntroCardWidget(
//                                       condition: color,
//                                       isPortrait: isPortrait,
//                                       // Pass prayer state to IntroCardWidget if needed
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               DelayedDisplay(
//                                 delay: const Duration(milliseconds: 100),
//                                 child: buildStopCardWidget(context, color: color),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: isPortrait ? 8.0 : 2.0,
//                                   horizontal: isPortrait ? 8.0 : 8.0,
//                                 ),
//                                 child: BuildServicesCardsWidget(
//                                   isPortrait: isPortrait,
//                                   isDark: appState.themeCurrentIndex == 0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
