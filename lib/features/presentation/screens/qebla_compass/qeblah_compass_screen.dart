import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
import 'package:vibration/vibration.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
  double begin = 0.0;
  Animation<double>? animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);

    // Load saved location or request permission
    context.read<LocationBloc>().add(LoadLocationEvent());
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _refreshLocation() => context.read<LocationBloc>().add(RefreshLocationEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "محدد القِبْلة", isLeading: false),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.kabbaBackgroundImage),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LocationInitial || state is LocationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LocationPermissionDenied || state is LocationPermissionPermanentlyDenied) {
              return _buildPermissionDeniedUI(state);
            }

            if (state is LocationSaved) {
              return _buildQiblahCompass(state);
            }

            return Center(
              child: Text(
                'حدث خطأ غير متوقع',
                style: TextStyle(fontSize: 24.sp),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshLocation,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildPermissionDeniedUI(LocationState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 50.sp,
            color: Colors.red,
          ),
          SizedBox(height: 20.h),
          Text(
            state is LocationPermissionPermanentlyDenied
                ? 'إذن الموقع مرفوض نهائياً. يرجى تمكينه من إعدادات الجهاز'
                : 'تم رفض إذن الوصول للموقع',
            style: TextStyle(
              fontSize: AppConsts.font18size,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              if (state is LocationPermissionPermanentlyDenied) {
                openAppSettings();
              } else {
                context.read<LocationBloc>().add(RequestLocationPermissionEvent());
              }
            },
            child: Text(
              state is LocationPermissionPermanentlyDenied ? 'فتح الإعدادات' : 'منح الإذن',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblahCompass(LocationSaved state) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 24.sp),
            ),
          );
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return Center(
            child: Text(
              'اتجاه القبلة غير متوفر',
              style: TextStyle(fontSize: 24.sp),
            ),
          );
        }

        animation = Tween(begin: begin, end: (qiblahDirection.qiblah * (pi / 180) * -1)).animate(_animationController!);
        begin = (qiblahDirection.qiblah * (pi / 180) * -1);
        _animationController!.forward(from: 0);

        const double tolerance = 5.0;
        if ((qiblahDirection.direction - qiblahDirection.qiblah).abs() <= tolerance) {
          Vibration.hasVibrator().then((hasVibrator) {
            if (hasVibrator == true) {
              Vibration.vibrate(duration: 500);
            }
          });
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "المدينة: ${state.city}",
                style: TextStyle(fontSize: AppConsts.font16size),
              ),
              SizedBox(height: 10.h),
              Text(
                "${qiblahDirection.direction.toInt()}°",
                style: TextStyle(fontSize: 24.sp),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: AnimatedBuilder(
                  animation: animation!,
                  builder: (context, child) => Transform.rotate(
                    angle: animation!.value,
                    child: Image.asset(AppAssets.qiblaCompassImage),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
