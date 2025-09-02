import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
  double begin = 0.0;
  Animation<double>? animation;
  AnimationController? _animationController;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    _initQiblah();
  }

  Future<void> _initQiblah() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // التحقق من حالة الموقع والإذن
      final locationStatus = await FlutterQiblah.checkLocationStatus();

      if (locationStatus.enabled && locationStatus.status == LocationPermission.always) {
        // كل شيء جاهز
        setState(() => _isLoading = false);
      } else if (locationStatus.status == LocationPermission.denied) {
        // الإذن مرفوض، نطلبه
        final status = await Permission.location.request();
        if (status.isGranted) {
          setState(() => _isLoading = false);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'تم رفض إذن الوصول للموقع';
          });
        }
      } else if (!locationStatus.enabled) {
        // خدمة الموقع غير مفعلة
        setState(() {
          _isLoading = false;
          _errorMessage = 'خدمة الموقع غير مفعلة. يرجى تمكينها';
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _refreshLocation() {
    _initQiblah();
  }

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
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        fontSize: AppConsts.font18size,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: _initQiblah,
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is LocationPermissionDenied || state is LocationPermissionPermanentlyDenied) {
              return _buildPermissionDeniedUI(state);
            }

            return _buildQiblahCompass(state);
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

  Widget _buildQiblahCompass(LocationState state) {
    String city = "غير معروف";

    if (state is LocationSaved) {
      city = state.city;
    } else if (state is LocationHasSavedData) {
      city = state.locationData["city"] ?? "غير معروف";
    }

    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${snapshot.error.toString()}',
                  style: TextStyle(fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _refreshLocation,
                  child: Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'اتجاه القبلة غير متوفر',
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _refreshLocation,
                  child: Text('إعادة المحاولة'),
                ),
              ],
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

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "المدينة: $city",
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

// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quran_life_muslim/core/enums/message_type.dart';
// import 'package:quran_life_muslim/core/utils/assets/assets.dart';
// import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
// import 'package:quran_life_muslim/features/presentation/manage/location/location_bloc.dart';
// import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
// import 'package:quran_life_muslim/features/presentation/widgets/custom_snack_bar/snackbar_widget.dart';
//
// class QiblahScreen extends StatefulWidget {
//   const QiblahScreen({super.key});
//
//   @override
//   State<QiblahScreen> createState() => _QiblahScreenState();
// }
//
// class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
//   double begin = 0.0;
//   Animation<double>? animation;
//   AnimationController? _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
//     animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
//
//     // Load saved location or request permission
//     // context.read<LocationBloc>().add(LoadLocationEvent());
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     super.dispose();
//   }
//
//   void _refreshLocation() => context.read<LocationBloc>()..add(RefreshLocationEvent());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(context, title: "محدد القِبْلة", isLeading: false),
//       extendBodyBehindAppBar: true,
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssets.kabbaBackgroundImage),
//             fit: BoxFit.cover,
//             opacity: 0.5,
//           ),
//         ),
//         child: BlocConsumer<LocationBloc, LocationState>(
//           listener: (context, state) {
//             if (state is LocationError) {
//               showCustomSnackBar(context: context, title: state.message, duration: 2, type: MessageType.error);
//             }
//           },
//           builder: (context, state) {
//             if (state is LocationInitial || state is LocationLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (state is LocationPermissionDenied || state is LocationPermissionPermanentlyDenied) {
//               return _buildPermissionDeniedUI(state);
//             }
//
//             if (state is LocationSaved || state is LocationHasSavedData) {
//               return _buildQiblahCompass(state);
//             }
//
//             // if (state is LocationHasSavedData) {
//             //   return _buildQiblahCompass(state);
//             // }
//
//             return Center(
//               child: Text(
//                 'حدث خطأ غير متوقع',
//                 style: TextStyle(fontSize: 24.sp),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _refreshLocation,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
//
//   Widget _buildPermissionDeniedUI(LocationState state) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.location_off,
//             size: 50.sp,
//             color: Colors.red,
//           ),
//           SizedBox(height: 20.h),
//           Text(
//             state is LocationPermissionPermanentlyDenied
//                 ? 'إذن الموقع مرفوض نهائياً. يرجى تمكينه من إعدادات الجهاز'
//                 : 'تم رفض إذن الوصول للموقع',
//             style: TextStyle(
//               fontSize: AppConsts.font18size,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20.h),
//           ElevatedButton(
//             onPressed: () {
//               if (state is LocationPermissionPermanentlyDenied) {
//                 openAppSettings();
//               } else {
//                 context.read<LocationBloc>().add(RequestLocationPermissionEvent());
//               }
//             },
//             child: Text(
//               state is LocationPermissionPermanentlyDenied ? 'فتح الإعدادات' : 'منح الإذن',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQiblahCompass(LocationState state) {
//     double latitude;
//     double longitude;
//     String city;
//
//     if (state is LocationSaved) {
//       latitude = state.latitude;
//       longitude = state.longitude;
//       city = state.city;
//     } else if (state is LocationHasSavedData) {
//       latitude = state.locationData["latitude"];
//       longitude = state.locationData["longitude"];
//       city = state.locationData["city"] ?? "غير معروف";
//     } else {
//       latitude = 0.0;
//       longitude = 0.0;
//       city = "غير معروف";
//     }
//
//     return StreamBuilder(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error: ${snapshot.error}',
//               style: TextStyle(fontSize: 24.sp),
//             ),
//           );
//         }
//
//         final qiblahDirection = snapshot.data;
//         if (qiblahDirection == null) {
//           return Center(
//             child: Text(
//               'اتجاه القبلة غير متوفر',
//               style: TextStyle(fontSize: 24.sp),
//             ),
//           );
//         }
//
//         animation = Tween(begin: begin, end: (qiblahDirection.qiblah * (pi / 180) * -1)).animate(_animationController!);
//         begin = (qiblahDirection.qiblah * (pi / 180) * -1);
//         _animationController!.forward(from: 0);
//
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "المدينة: $city",
//                 style: TextStyle(fontSize: AppConsts.font16size),
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 "${qiblahDirection.direction.toInt()}°",
//                 style: TextStyle(fontSize: 24.sp),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 300,
//                 child: AnimatedBuilder(
//                   animation: animation!,
//                   builder: (context, child) => Transform.rotate(
//                     angle: animation!.value,
//                     child: Image.asset(AppAssets.qiblaCompassImage),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
// }
