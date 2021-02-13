import 'package:flutter/material.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/video_model.dart';
import 'package:ytanim/video_player.dart';

import 'extensions.dart';

class VideoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final size = context.screenSize;
    return Container(
      color: Colors.grey[400],
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: controller.isMinimized
          ? MiniPlayer(video: controller.nowPlaying)
          : Column(
              children: [
                if (controller.isPlaying) RegularPlayer(video: controller.nowPlaying),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () => context.readVideoController.stopPlaying(),
                ),
              ],
            ),
    );
  }
}

class RegularPlayer extends StatelessWidget {
  final Video video;

  const RegularPlayer({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 1.0) {
            context.readVideoController.minimize();
          }
          // print(details.delta);
        },
        child: VideoPlayerSimple() ?? Image.asset(video.thumbnail),
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final Video video;

  const MiniPlayer({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kMiniPlayerHeight,
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () => context.readVideoController.maximize(),
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -0.8) {
                  context.readVideoController.maximize();
                }
                // print(details.delta);
              },
              child: VideoPlayerSimple() ?? Image.asset(video.thumbnail, height: kMiniPlayerHeight),
            ),
          ),
          Expanded(
            child: Text(video.title, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.pause), onPressed: null),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => context.readVideoController.stopPlaying(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
