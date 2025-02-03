import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
    return Scaffold(
      body: Column(
        children: [
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : const SizedBox(),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url:WebUri(url)),
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
                  // افتح الرابط في المتصفح الخارجي:
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              // دعم عرض صفحة بديلة عند فقدان الاتصال:
              onLoadError: (controller, url, code, message) {
                controller.loadData(data: """
                  <html>
                  <body>
                    <h1>لا يوجد اتصال بالإنترنت</h1>
                    <p>يرجى التأكد من اتصالك وإعادة المحاولة.</p>
                  </body>
                  </html>
                """, mimeType: 'text/html', encoding: 'utf-8');
              },
            ),
          ),
        ],
      ),
    );
  }
}
