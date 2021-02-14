import 'package:flutter/material.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/video_player.dart';

import 'extensions.dart';

class VideoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;

    if (!controller.hasVideo) return FullSizedContainer();

    return FullSizedContainer(
      child: controller.isMinimized ? const MiniPlayer() : const RegularPlayer(),
    );
  }
}

class RegularPlayer extends StatelessWidget {
  const RegularPlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final video = controller.nowPlaying;
    return Column(
      children: [
        Flexible(
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
              child: VideoPlayer(),
            ),
          ),
        ),
        Text(video.title),
        ElevatedButton.icon(
          label: Text('Stop'),
          style: ElevatedButton.styleFrom(primary: Colors.red),
          icon: Icon(Icons.stop),
          onPressed: controller.stopPlaying,
        ),
        ElevatedButton.icon(
          label: Text('Minimize'),
          icon: Icon(Icons.minimize),
          onPressed: controller.minimize,
        ),
      ],
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final video = controller.nowPlaying;
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
          Expanded(
            child: GestureDetector(
              onTap: controller.maximize,
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -0.8) {
                  controller.maximize();
                }
              },
              child: Container(
                color: Colors.grey[850],
                child: Row(
                  children: [
                    VideoPlayer(),
                    SizedBox(width: 4),
                    Flexible(child: Text(video.title, maxLines: 3, overflow: TextOverflow.ellipsis))
                  ],
                ),
              ),
            ),
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

class FullSizedContainer extends StatelessWidget {
  final Widget child;

  const FullSizedContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return Container(
      color: Colors.grey[850],
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}
