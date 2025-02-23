import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart'; // أضف هذه الحزمة
import 'package:quran_life_muslim/core/utils/assets/assets.dart';
import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
    } else {
      setState(() {
        _locationPermissionGranted = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
    } else {
      openAppSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required for Qibla direction.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context, title: "محدد القبلة", isLeading: false),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.kabbaBackgroundImage),
                  fit: BoxFit.cover,
                  opacity: 0.5)),
          child: StreamBuilder(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshot) {
              if (!_locationPermissionGranted) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: _requestLocationPermission, icon: Icon(Icons.location_off_rounded, size: 40.sp)),
                      SizedBox(height: 10.h),
                      Text(
                        'لا يوجد أذونات الوصول إلى الموقع',
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'اضغط على الأيقونة لكي تحدد القبلة',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
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
                    'Qiblah direction not available',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                );
              }

              animation = Tween(begin: begin, end: (qiblahDirection.qiblah * (pi / 180) * -1))
                  .animate(_animationController!);
              begin = (qiblahDirection.qiblah * (pi / 180) * -1);
              _animationController!.forward(from: 0);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${qiblahDirection.direction.toInt()}°",
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
          ),
        ),
      ),
    );
  }
}

// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quran_life_muslim/core/utils/assets/assets.dart';
// import 'package:quran_life_muslim/features/presentation/widgets/custom_appbar/build_appbar.dart';
//
// class QiblahScreen extends StatefulWidget {
//   const QiblahScreen({super.key});
//
//   @override
//   State<QiblahScreen> createState() => _QiblahScreenState();
// }
//
// Animation<double>? animation;
// AnimationController? _animationController;
// double begin = 0.0;
//
// class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         // body: StreamBuilder(
//         //   stream: FlutterQiblah.qiblahStream,
//         //   builder: (context, snapshot) {
//         //     if (snapshot.connectionState == ConnectionState.waiting) {
//         //       return Container(
//         //           alignment: Alignment.center,
//         //           child: const CircularProgressIndicator(
//         //             color: Colors.white,
//         //           ));
//         //     }
//         //
//         //     final qiblahDirection = snapshot.data;
//         //     animation = Tween(begin: begin, end: (qiblahDirection!.qiblah * (pi / 180) * -1))
//         //         .animate(_animationController!);
//         //     begin = (qiblahDirection.qiblah * (pi / 180) * -1);
//         //     _animationController!.forward(from: 0);
//         //
//         //     return Center(
//         //       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         //         Text(
//         //           "${qiblahDirection.direction.toInt()}°",
//         //           style: const TextStyle(color: Colors.white, fontSize: 24),
//         //         ),
//         //         const SizedBox(
//         //           height: 10,
//         //         ),
//         //         SizedBox(
//         //             height: 300,
//         //             child: AnimatedBuilder(
//         //               animation: animation!,
//         //               builder: (context, child) => Transform.rotate(
//         //                   angle: animation!.value, child: Image.asset(AppAssets.qiblaCompassImage)),
//         //             ))
//         //       ]),
//         //     );
//         //   },
//         // ),
//         appBar: buildAppBar(context, title: "محدد القبلة", isLeading: false),
//         extendBodyBehindAppBar: true,
//         body: StreamBuilder(
//           stream: FlutterQiblah.qiblahStream,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Container(
//                 alignment: Alignment.center,
//                 child: const CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               );
//             }
//
//             if (snapshot.hasError) {
//               return Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.location_off_rounded, size: 40.sp),
//                     SizedBox(height: 10.h),
//                     Text('لا يوجد أذونات الوصول إلى اللوكيشن',
//                         style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
//                     // Text(
//                     //   'Error: ${snapshot.error}',
//                     //   style: TextStyle(color: Colors.white, fontSize: 24.sp),
//                     // ),
//                   ],
//                 ),
//               );
//             }
//
//             final qiblahDirection = snapshot.data;
//             if (qiblahDirection == null) {
//               return const Center(
//                 child: Text(
//                   'Qiblah direction not available',
//                   style: TextStyle(color: Colors.white, fontSize: 24),
//                 ),
//               );
//             }
//
//             animation = Tween(begin: begin, end: (qiblahDirection.qiblah * (pi / 180) * -1))
//                 .animate(_animationController!);
//             begin = (qiblahDirection.qiblah * (pi / 180) * -1);
//             _animationController!.forward(from: 0);
//
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "${qiblahDirection.direction.toInt()}°",
//                     style: const TextStyle(color: Colors.white, fontSize: 24),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     height: 300,
//                     child: AnimatedBuilder(
//                       animation: animation!,
//                       builder: (context, child) => Transform.rotate(
//                         angle: animation!.value,
//                         child: Image.asset(AppAssets.qiblaCompassImage),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_qiblah/flutter_qiblah.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
// //
// // class QiblahScreen extends StatefulWidget {
// //   const QiblahScreen({super.key});
// //
// //   @override
// //   State<QiblahScreen> createState() => _QiblahScreenState();
// // }
// //
// // class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
// //   Animation<double>? animation;
// //   AnimationController? _animationController;
// //   double begin = 0.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
// //     _checkLocationPermission();
// //   }
// //
// //   Future<void> _checkLocationPermission() async {
// //     var status = await Permission.locationWhenInUse.status;
// //     if (status.isDenied || status.isPermanentlyDenied) {
// //       _showPermissionDialog();
// //     } else {
// //       _fetchQiblahDirection();
// //     }
// //   }
// //
// //   Future<void> _fetchQiblahDirection() async {
// //     final location = await SharedPrefController.getLocation();
// //     final latitude = location['latitude'];
// //     final longitude = location['longitude'];
// //
// //     if (latitude == 0.0 || longitude == 0.0) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Location not found. Please enable location services.')),
// //       );
// //       return;
// //     }
// //
// //     // Use latitude and longitude for Qibla calculation
// //     // (FlutterQiblah will handle this internally)
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: const Color.fromARGB(255, 48, 48, 48),
// //         body: FutureBuilder(
// //           future: Permission.locationWhenInUse.isGranted,
// //           builder: (context, AsyncSnapshot<bool> snapshot) {
// //             if (!snapshot.hasData || !snapshot.data!) {
// //               return const Center(
// //                 child: Text(
// //                   "يجب عليك تفعيل أذونات الموقع لتتمكن من تشغيل بوصلة القبلة",
// //                   style: TextStyle(color: Colors.white),
// //                   textAlign: TextAlign.center,
// //                 ),
// //               );
// //             }
// //
// //             return StreamBuilder(
// //               stream: FlutterQiblah.qiblahStream,
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(child: CircularProgressIndicator(color: Colors.white));
// //                 }
// //
// //                 if (snapshot.hasError) {
// //                   return Center(
// //                     child: Text(
// //                       'Error: ${snapshot.error}',
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                   );
// //                 }
// //
// //                 final qiblahDirection = snapshot.data;
// //                 if (qiblahDirection == null) {
// //                   return const Center(
// //                     child: Text(
// //                       'Unable to fetch Qiblah direction',
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   );
// //                 }
// //
// //                 animation = Tween(begin: begin, end: (qiblahDirection.qiblah * (pi / 180) * -1))
// //                     .animate(_animationController!);
// //                 begin = (qiblahDirection.qiblah * (pi / 180) * -1);
// //                 _animationController!.forward(from: 0);
// //
// //                 return Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         "${qiblahDirection.direction.toInt()}°",
// //                         style: const TextStyle(color: Colors.white, fontSize: 24),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       SizedBox(
// //                         height: 300,
// //                         child: AnimatedBuilder(
// //                           animation: animation!,
// //                           builder: (context, child) => Transform.rotate(
// //                             angle: animation!.value,
// //                             child: Image.asset('assets/images/qibla.png'),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController?.dispose();
// //     super.dispose();
// //   }
// // }
