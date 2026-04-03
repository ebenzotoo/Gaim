import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Webview/web_view_loading.dart';

class Evangelism extends StatefulWidget {
  const Evangelism({super.key});

  @override
  State<Evangelism> createState() => _EvangelismState();
}

class _EvangelismState extends State<Evangelism> {
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
        Uri.parse("https://godaloneint.org/become-a-member/"),
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
