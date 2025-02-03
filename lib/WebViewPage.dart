import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sezel/CustomLoading.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;
  String url = "https://sezelhelp.com/";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        // التحقق مما إذا كان الـ WebView يمكنه الرجوع
        if (webViewController != null) {
          bool canGoBack = await webViewController!.canGoBack();
          if (canGoBack) {
            webViewController!.goBack();
            return false; // منع إغلاق التطبيق
          }
        }
        return true; // إذا لم يكن هناك صفحة سابقة داخل WebView، يسمح بالرجوع (أي الخروج من التطبيق)
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
                // منع فتح الروابط الخارجية داخل التطبيق:
                if (uri != null && !uri.toString().contains("sezelhelp.com")) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              // دعم عرض صفحة بديلة عند فقدان الاتصال:
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
                    encoding: 'utf-8'
                );
              },
            ),
            // شاشة التحميل (إذا كنت تستخدمها)
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
