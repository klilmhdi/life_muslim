// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
// class RemoteNotificationService {
//   static Future<void> init() async {
//     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//     OneSignal.initialize("2b8a0b3f-65ee-47c7-a872-03caed710052");
//     OneSignal.Notifications.requestPermission(true);
//     await initFcmToken();
//   }
//
//   static Future<String?> initFcmToken() async {
//     final token = await FirebaseMessaging.instance.getToken();
//     debugPrint("-------- FCM token: $token");
//     return token;
//   }
// }
