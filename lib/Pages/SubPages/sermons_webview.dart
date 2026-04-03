import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Webview/web_view_loading.dart';

class SermonsWebview extends StatefulWidget {
  const SermonsWebview({super.key});

  @override
  State<SermonsWebview> createState() => _SermonsWebviewState();
}

class _SermonsWebviewState extends State<SermonsWebview> {
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
        Uri.parse("https://godaloneint.org/sermons/"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: _isLoading
          ? const WebViewLoadingPage()
          : WebViewWidget(controller: videoPageController),
    );
  }
}
