import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sezel/CustomLoading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;
  String url = "https://sezelhelp.com/";
  double progress = 0;

  // اشتراك لحالة الاتصال
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // الاشتراك في تغييرات الاتصال
    late StreamSubscription<ConnectivityResult> connectivitySubscription;

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
    connectivitySubscription.cancel(); // إلغاء الاشتراك عند التخلص من الودجة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // معالجة زر الرجوع، إذا كان بإمكان الـ WebView العودة لصفحة سابقة
        if (webViewController != null && await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
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
              // عرض صفحة بديلة عند فقدان الاتصال
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
            // شاشة التحميل: تظهر مؤقتًا حتى ينتهي تحميل الموقع
            if (progress < 1.0)
              Container(
                color: Colors.white,
                child: Customloading(),
                ),
          ],
        ),
      ),
    );
  }
}
