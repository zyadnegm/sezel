import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sezel/CustomLoading.dart';
import 'package:sezel/UserInfo_Model.dart';
import 'package:sezel/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'ApiService.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, this.fcmtoken});
  final String? fcmtoken;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  InAppWebViewController? webViewController;
  final String url = "https://sezelhelp.com/";
  double progress = 0;
  final WebUri loginUrl = WebUri("https://sezelhelp.com/?login=true");
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .map((results) => results.first) // استخراج أول عنصر من القائمة
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (webViewController != null && await webViewController!.canGoBack()) {
          webViewController!.goBack();
        }
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
                  ),
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
                  final uri = navigationAction.request.url;
                  if (uri != null &&
                      !uri.toString().contains("sezelhelp.com")) {
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  if (url.toString().contains("https://sezelhelp.com")) {
                    final cookieManager = CookieManager();
                    final cookies = await cookieManager.getCookies(
                        url: WebUri("https://sezelhelp.com"));
                    final cookieHeader =
                        cookies.map((e) => "${e.name}=${e.value}").join("; ");

                    if (cookies.isNotEmpty) {
                      debugPrint("🍪 ✅ تم جلب الكوكيز: $cookieHeader");
                      final apiService = ApiService();
                      apiService.setCookies(cookieHeader);
                      final tokens = await apiService.login();

                      if (tokens != null) {
                        final user =
                            User_Model(widget.fcmtoken!, tokens[0], tokens[1]);
                        Firebase_Function.add_user(user);
                        debugPrint("🔑 Token: ${tokens[0]}");
                        debugPrint("🔑 user_id: ${tokens[1]}");
                      }
                    } else {
                      debugPrint("🚨 لا توجد كوكيز متاحة!");
                    }
                  }
                },
                onLoadError: (controller, url, code, message) {
                  controller.loadData(
                    data: """
                      <html>
                        <head>
                          <meta name='viewport' content='width=device-width, initial-scale=1.0'>
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
                  child: const Customloading(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
