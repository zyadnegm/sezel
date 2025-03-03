import 'package:flutter/material.dart';

import 'homepage.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key, required this.fcmtoken});
  final String? fcmtoken;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Homepage(
          fcmtoken: fcmtoken,
        ),
      ),
    );
  }
}