import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ytanim/video_model.dart';

import 'extensions.dart';

class VideoPlayerSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.videoWidget,
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final Video video;

  const VideoPlayer({Key key, this.video}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController vC;
  ChewieController cC;

  @override
  void initState() {
    super.initState();
    vC = VideoPlayerController.asset(widget.video.src);
    _startUp();
  }

  Future<void> _startUp() async {
    await vC.initialize();
    cC = ChewieController(
      videoPlayerController: vC,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    vC.dispose();
    cC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: cC == null
          ? Center(child: CircularProgressIndicator())
          : Chewie(
              controller: cC,
            ),
    );
  }
}
