import 'package:flutter/material.dart';

import 'ApiService.dart';
import 'Notifications/Firebase_Messeging.dart';
import 'homepage.dart';


class WebViewPage extends StatefulWidget {
   WebViewPage({Key? key}) : super(key: key);
  late String f;


  @override
  State<WebViewPage> createState() => _WebViewPageState();
}


class _WebViewPageState extends State<WebViewPage> {

  @override
  void initState() {
    super.initState();
    _initializeData(); // استدعاء دالة مستقلة
  }

  void _initializeData() async {
    String? fcmtoken = await Firebase_Messeging().gettoken();
    var jwttoken = await ApiService().login();
    print("=====================Token=$jwttoken");

    if (jwttoken == null) {
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("برجاء تسجيل الدخول "),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      print("+++++++++++++++++Token=$jwttoken");
      await ApiService().getNotifications(jwttoken);
      await ApiService().sendNotification(jwttoken, fcmtoken!);

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Homepage(),
      ),
    );
  }
}