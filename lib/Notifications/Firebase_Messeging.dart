import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sezel/ApiService.dart';

class Firebase_Messeging {
  ApiService apiService = ApiService();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initnotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> gettoken() async {
    await messaging.requestPermission();
    String? fcmtoken = await messaging.getToken();
    print("+++++++++fcm : $fcmtoken");
    return fcmtoken;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("+++++++++++${message.data}====================");
  }
}
