import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sezel/WebViewPage.dart';
import 'Notifications/Firebase_Messeging.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ جلب التوكن قبل تشغيل التطبيق
  String? token = await Firebase_Messeging().gettoken();

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewPage(fcmtoken: token,), // ✅ تمرير التوكن إلى الصفحة
    );
  }
}
