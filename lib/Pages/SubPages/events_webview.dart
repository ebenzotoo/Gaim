import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Webview/web_view_loading.dart';

class EventseWebview extends StatefulWidget {
  const EventseWebview({super.key});

  @override
  State<EventseWebview> createState() => _EventseWebviewState();
}

class _EventseWebviewState extends State<EventseWebview> {
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
        Uri.parse("https://godaloneint.org/events/"),
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
