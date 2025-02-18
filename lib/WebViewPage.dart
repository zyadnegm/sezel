import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sezel/CustomLoading.dart';
import 'package:sezel/homepage.dart';
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

  WebUri loginUrl = WebUri("https://sezelhelp.com/?login=true");
  late StreamSubscription<ConnectivityResult> connectivitySubscription;


  @override

  void initState() {
    super.initState();

    // الاشتراك في تغييرات الاتصال
    // late StreamSubscription<ConnectivityResult> connectivitySubscription;

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
                    )
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;

                  webViewController?.addJavaScriptHandler(
                    handlerName: 'getEmailValue',
                    callback: (args) {
                      if (args.isNotEmpty) {
                        String emailValue = args[0];
                        print("Email entered by user: $emailValue");
                      } else {
                        print("No email value received.");
                      }
                    },
                  );

                  webViewController?.addJavaScriptHandler(
                    handlerName: 'getPasswordValue',
                    callback: (args) {
                      if (args.isNotEmpty) {
                        String passwordValue = args[0];
                        print("Password entered by user: $passwordValue");
                      } else {
                        print("No password value received.");
                      }
                    },
                  );
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
                  if (url.toString().contains("register")) {
                    // Separate JavaScript code for email
                    await webViewController?.evaluateJavascript(source: """
                      (function() {
                        let emailInput = document.querySelector('input[name="digits_reg_name"]');
                        if (emailInput) {
                          emailInput.addEventListener('input', function() {
                            window.flutter_inappwebview.callHandler('getEmailValue', this.value);
                          });
                          window.flutter_inappwebview.callHandler('getEmailValue', emailInput.value); // Initial value
                        } else {
                          console.error('Email input field not found!');
                        }
                      })();
                    """);

                    // Separate JavaScript code for password
                    await webViewController?.evaluateJavascript(source: """
                      (function() {
                        let passwordInput = document.querySelector('input[name="digits_reg_password"]');
                        if (passwordInput) {
                          passwordInput.addEventListener('input', function() {
                            window.flutter_inappwebview.callHandler('getPasswordValue', this.value);
                          });
                          window.flutter_inappwebview.callHandler('getPasswordValue', passwordInput.value); // Initial value
                        } else {
                          console.error('Password input field not found!');
                        }
                      })();
                    """);
                  }
                },
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