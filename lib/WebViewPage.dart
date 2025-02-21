import 'package:flutter/material.dart';

import 'ApiService.dart';
import 'Notifications/Firebase_Messeging.dart';
import 'homepage.dart';


class WebViewPage extends StatelessWidget {
   WebViewPage({Key? key, required this.fcmtoken}) : super(key: key);
  final String? fcmtoken;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Homepage(fcmtoken: fcmtoken,),
      ),
    );
  }
}