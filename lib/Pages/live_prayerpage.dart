import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:godalone/Pages/SubPages/live_service_webview.dart';
import 'package:video_player/video_player.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
            'https://godaloneint.org/wp-content/uploads/2024/10/10000000_1046724750466620_2733094960125189219_n-1.mp4')));
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(
          child: Padding(
        padding: EdgeInsets.only(top: 160, bottom: 160),
        child: LiveServiceWebview(),
      )
          // AspectRatio(
          //     aspectRatio: 16 / 10,
          //     child: FlickVideoPlayer(flickManager: flickManager)),
          ),
    );
  }
}
