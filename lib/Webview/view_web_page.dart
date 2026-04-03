import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_view_loading.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoading = true;
  late final WebViewController videoPageController;

  @override
  void initState() {
    super.initState();
    videoPageController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      // change the url here
      ..loadRequest(
        Uri.parse("https://www.youtube.com/@stephenacheampong6175/streams"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const WebViewLoadingPage()
          : WebViewWidget(controller: videoPageController),
    );
  }
}
