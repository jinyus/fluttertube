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
    final video = controller.nowPlaying;
    return Container(
      color: Colors.grey[850],
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: controller.isMinimized
          ? MiniPlayer(video: video)
          : Column(
              children: [
                if (controller.hasVideo) ...[
                  RegularPlayer(video: video),
                  Text('(${video.id}) ${video.title}'),
                  ElevatedButton.icon(
                    label: Text('Stop'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    icon: Icon(Icons.stop),
                    onPressed: () => context.readVideoController.stopPlaying(),
                  ),
                  ElevatedButton.icon(
                    label: Text('Minimize'),
                    icon: Icon(Icons.minimize),
                    onPressed: () => context.readVideoController.minimize(),
                  ),
                ]
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
        child: Container(
          constraints: BoxConstraints(maxHeight: context.screenSize.height * 0.65),
          width: double.infinity,
          child: VideoPlayerSimple(),
        ),
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final Video video;

  const MiniPlayer({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //read here because the parent will rebuild when the state changes
    final controller = context.readVideoController;
    return Container(
      height: kMiniPlayerHeight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: .5, color: Colors.red.shade500),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: controller.maximize,
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -0.8) {
                  controller.maximize();
                }
                // print(details.delta);
              },
              child: VideoPlayerSimple(),
            ),
          ),
          Expanded(
            child: Text(video.title, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(controller.miniplayerPaused ? Icons.play_arrow : Icons.pause),
                  onPressed: controller.toggleMiniPlayerPause),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: controller.stopPlaying,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
