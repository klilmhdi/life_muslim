import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_button/buttons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../core/enums/message_type.dart';
import '../../../../../core/shared_preferenced/shared_preferenced.dart';
import '../../../../data/models/adhan/azan_by_month_model.dart';
import '../../../manage/location/location_bloc.dart';
import '../../../manage/preyer_timing/for_month/monthly_prayer_timing_bloc.dart';
import '../../../widgets/build_prayer_widgets/prayer_monthly_widgets.dart';
import '../../../widgets/custom_snack_bar/snackbar_widget.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  PrayerTimesScreenState createState() => PrayerTimesScreenState();
}

class PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late PrayerDataSource prayerDataSource;
  final DataGridController _dataGridController = DataGridController();
  bool _hasRequestedData = false;

  @override
  void initState() {
    super.initState();
    prayerDataSource = PrayerDataSource();
    prayerDataSource.updateData([]);
    context.read<LocationBloc>().add(LoadLocationEvent());
  }

  void _fetchPrayerTimes(LocationState state) {
    if (_hasRequestedData) return; // منع الطلبات المتكررة

    double lat;
    double long;

    if (state is LocationSaved) {
      lat = state.latitude;
      long = state.longitude;
    } else if (state is LocationHasSavedData) {
      lat = state.locationData["latitude"];
      long = state.locationData["longitude"];
    } else {
      return;
    }

    _hasRequestedData = true;
    context.read<MonthlyPrayerTimingBloc>().add(FetchPrayerTimes(
          lat: lat,
          long: long,
          year: DateTime.now().year,
          month: DateTime.now().month,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "مواعيد الآذان لهذا الشهر", isLeading: false),
      extendBodyBehindAppBar: true,
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationSaved || state is LocationHasSavedData) {
            _fetchPrayerTimes(state);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.fourthBackgroundImage),
              fit: BoxFit.cover,
              opacity: 0.38,
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locationState) {
                if (locationState is LocationSaved || locationState is LocationHasSavedData) {
                  return BlocConsumer<MonthlyPrayerTimingBloc, MonthlyPrayerTimingState>(
                    listener: (context, prayerState) {
                      if (prayerState is MonthlyPrayerTimesError) {
                        _hasRequestedData = false; // السماح بإعادة المحاولة
                        showCustomSnackBar(
                          context: context,
                          title: "حاول في وقت لاحق",
                          duration: 300,
                          type: MessageType.error,
                        );
                      } else if (prayerState is MonthlyPrayerTimesLoaded) {
                        _hasRequestedData = false; // إعادة تعيين للطلبات المستقبلية
                      }
                    },
                    builder: (context, prayerState) {
                      if (prayerState is MonthlyPrayerTimesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (prayerState is MonthlyPrayerTimesLoaded) {
                        final prayerDays = prayerState.prayerTimings.data?.map((data) {
                              final hijriDate = data.date?.hijri;
                              final gregorianDate = data.date?.gregorian;
                              return PrayerDay(
                                day: hijriDate?.weekday?.ar ?? '',
                                date: gregorianDate?.date ?? '',
                                fajr: formatTimeTo12Hour(data.timings?.fajr?.split(' ')[0] ?? ''),
                                dhuhr: formatTimeTo12Hour(data.timings?.dhuhr?.split(' ')[0] ?? ''),
                                asr: formatTimeTo12Hour(data.timings?.asr?.split(' ')[0] ?? ''),
                                maghrib: formatTimeTo12Hour(data.timings?.maghrib?.split(' ')[0] ?? ''),
                                isha: formatTimeTo12Hour(data.timings?.isha?.split(' ')[0] ?? ''),
                              );
                            }).toList() ??
                            [];

                        prayerDataSource.updateData(prayerDays);

                        return FutureBuilder<Map<String, dynamic>>(
                            future: SharedPrefController.getLocation(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              final city = snapshot.data?['city'] ?? '';
                              final country = snapshot.data?['country'] ?? '';

                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(AppConsts.font8size),
                                      child: Text(
                                        "حسب التوقيت المحلي لموقعك: $city، $country",
                                        style: TextStyle(
                                          fontSize: AppConsts.font12size,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: buildTable(
                                      controller: _dataGridController,
                                      source: prayerDataSource,
                                    ),
                                  ),
                                  buildPaging(source: prayerDataSource)
                                ],
                              );
                            });
                      } else if (prayerState is MonthlyPrayerTimesError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.report_problem_rounded,
                                size: AppConsts.font40size,
                                color: CupertinoColors.destructiveRed,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                prayerState.message,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConsts.font18size,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80.sp),
                                child: basicButton(
                                  onPressed: () async {
                                    final location = await SharedPrefController.getLocation();
                                    context.read<MonthlyPrayerTimingBloc>().add(FetchPrayerTimes(
                                          lat: location['latitude'],
                                          long: location['longitude'],
                                          year: DateTime.now().year,
                                          month: DateTime.now().month,
                                        ));
                                  },
                                  text: 'إعادة المحاولة',
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                } else if (locationState is LocationError ||
                    locationState is LocationPermissionDenied ||
                    locationState is LocationPermissionPermanentlyDenied) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: AppConsts.font40size,
                          color: CupertinoColors.destructiveRed,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "لم يتم أخذ أذونات الموقع",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppConsts.font16size,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 80.sp),
                          child: basicButton(
                            onPressed: () {
                              if (locationState is LocationPermissionPermanentlyDenied) {
                                openAppSettings();
                              } else {
                                context.read<LocationBloc>().add(RequestLocationPermissionEvent());
                              }
                            },
                            text: locationState is LocationPermissionPermanentlyDenied ? 'فتح الإعدادات' : 'منح الإذن',
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
