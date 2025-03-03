import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sezel/Notifications/Firebase_Messeging.dart';
import 'animated_splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Firebase_Messeging().initnotification();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(), // ✅ تمرير التوكن إلى الصفحة
    );
  }
}