import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sezel/WebViewPage.dart';
import 'Notifications/Firebase_Messeging.dart';
import 'animated_splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {



  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(), // ✅ تمرير التوكن إلى الصفحة
    );
  }
}
