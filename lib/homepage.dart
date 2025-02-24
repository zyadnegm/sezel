import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sezel/ApiService.dart';
import 'package:sezel/Firebase_Database.dart';
import 'package:sezel/UserInfo_Model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


import 'CustomLoading.dart';

class Homepage extends StatefulWidget {
   Homepage({super.key, this.fcmtoken,});
   final String? fcmtoken;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  InAppWebViewController? webViewController;

  String url = "https://sezelhelp.com/";

  double progress = 0;

  WebUri loginUrl = WebUri("https://sezelhelp.com/?login=true");
  late StreamSubscription<ConnectivityResult> connectivitySubscription;


  @override

  void initState() {
    super.initState();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .map((results) => results.first)  // استخراج أول عنصر من القائمة
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // إعادة تحميل الصفحة عند استعادة الاتصال
        if (webViewController != null) {
          webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
        }
      }
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null && await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(



                initialUrlRequest: URLRequest(url: WebUri(url)),
                initialOptions: InAppWebViewGroupOptions(

                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      useOnLoadResource: true,

                    )
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;


                },
                onProgressChanged: (controller, progressValue) {
                  setState(() {
                    progress = progressValue / 100;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url;
                  if (uri != null && !uri.toString().contains("sezelhelp.com")) {
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  if (url.toString().contains("https://sezelhelp.com")) {
                    CookieManager cookieManager = CookieManager();
                    List<Cookie> cookies = await cookieManager.getCookies(
                      url: WebUri("https://sezelhelp.com"),
                    );

                    // تحويل الكوكيز إلى `String`
                    String cookieHeader = cookies.map((e) => "${e.name}=${e.value}").join("; ");

                    if (cookies.isNotEmpty) {
                      print("🍪 ✅ تم جلب الكوكيز: $cookieHeader");

                      // ضبط الهيدرز في Dio
                      ApiService apiService = ApiService();
                      apiService.setCookies(cookieHeader);

                      // استدعاء login()
                       List<dynamic>? tokens = await apiService.login();

    if (tokens != null) {
      User_Model user=User_Model(widget.fcmtoken!,tokens[0], tokens[1]);
      Firebase_Function.add_user(user);  }

                      print("🔑 Token: ${tokens![0]}");
                      print("🔑 user_id: ${tokens![1]}");



                    } else {
                      print("🚨 لا توجد كوكيز متاحة!");
                    }
                  }
                }
                ,
                onLoadError: (controller, url, code, message) {
                  controller.loadData(
                    data: """
                      <html>
                        <head>
                          <meta name="viewport" content="width=device-width, initial-scale=1.0">
                          <style>
                            body {
                              display: flex;
                              justify-content: center;
                              align-items: center;
                              height: 100vh;
                              margin: 0;
                              background-color: #ffffff;
                              font-family: sans-serif;
                            }
                            h1 {
                              font-size: 32px;
                              font-weight: bold;
                              color: #333;
                              text-align: center;
                            }
                          </style>
                        </head>
                        <body>
                          <h1>No Internet Connection</h1>
                        </body>
                      </html>
                    """,
                    mimeType: 'text/html',
                    encoding: 'utf-8',
                  );
                },
              ),
              if (progress < 1.0)
                Container(
                  color: Colors.white,
                  child: Customloading(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


// void _initializeData() async {
//   String? fcmtoken = await Firebase_Messeging().gettoken();
//   var jwttoken = await ApiService().login();
//   print("=====================Token=$jwttoken");
//
//   if (jwttoken == null) {
//     Future.microtask(() {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("برجاء تسجيل الدخول "),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     });
//   }
//   else {
//     print("+++++++++++++++++Token=$jwttoken");
//     await ApiService().getNotifications(jwttoken);
//     await ApiService().sendNotification(jwttoken, fcmtoken!);
//
//   }
// }