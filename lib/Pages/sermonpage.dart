import 'package:flutter/material.dart';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SermonPage extends StatefulWidget {
  const SermonPage({super.key});

  @override
  State<SermonPage> createState() => _SermonPageState();
}

class _SermonPageState extends State<SermonPage> {
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
      body: Center(
        child:
            // LiveServiceWebview()

            Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'MESSAGE OF THE WEEK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            AspectRatio(
                aspectRatio: 16 / 10,
                child: FlickVideoPlayer(flickManager: flickManager)),
          ],
        ),
      ),
    );
  }
}
