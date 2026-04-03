import 'package:flutter/material.dart';

class WebViewLoadingPage extends StatefulWidget {
  const WebViewLoadingPage({super.key});

  @override
  State<WebViewLoadingPage> createState() => _WebViewLoadingPageState();
}

class _WebViewLoadingPageState extends State<WebViewLoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(
        reverse: true,
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.secondary,
            Colors.white,
          ], begin: Alignment.topRight, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "THANK YOU FOR BEING HERE\nKINDLY BE PATIENT, LOADING...."),
              const SizedBox(
                height: 10,
              ),
              FadeTransition(
                opacity: _animationController,
                // change this to the church logo
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/2.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
