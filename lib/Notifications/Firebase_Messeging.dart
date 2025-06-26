import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sezel/ApiService.dart';
import 'package:url_launcher/url_launcher.dart';

class Firebase_Messeging {
  ApiService apiService = ApiService();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initnotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> gettoken() async {
    await messaging.requestPermission(
        sound: true,

    );
    String? fcmtoken = await messaging.getToken();
    // void sendTokenViaSMS(String token) async {
    //   final Uri sms = Uri.parse('sms:+201234567890?body=My FCM Token: $token');
    //   if (await canLaunchUrl(sms)) {
    //     await launchUrl(sms);
    //   }
    // }
    // sendTokenViaSMS(fcmtoken!);



    debugPrint("+++++++++fcm : $fcmtoken");
    return fcmtoken;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("+++++++++++${message.data}====================");
  }
}
