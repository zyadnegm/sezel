import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'Notifications/Firebase_Messeging.dart';
import 'firebase_options.dart';
import 'homepage.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({super.key});
  String? fcmtoken;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // ✅ جلب التوكن قبل تشغيل التطبيق
    String? token = await Firebase_Messeging().gettoken();

    setState(() {
      widget.fcmtoken = token;
    });

    // ✅ تعيين InAppWebViewPlatform
    InAppWebViewPlatform.instance = InAppWebViewPlatform.instance;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Homepage(
          fcmtoken: widget.fcmtoken, // ✅ مرر التوكن بعد التهيئة
        ),
      ),
    );
  }
}
