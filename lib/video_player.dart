import 'package:flutter/material.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/video_model.dart';

import 'extensions.dart';

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final size = controller.getSize(context.screenSize);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          if (controller.isPlaying && !controller.isMinimized) {
            controller.minimize();
            return false;
          }
          return true;
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: AnimatedContainer(
            duration: k1Second ~/ 3,
            color: Colors.grey[400],
            height: size.height,
            width: size.width,
            child: controller.isMinimized
                ? MiniPlayer(video: controller.nowPlaying)
                : controller.isPlaying
                    ? Column(
                        children: [
                          if (controller.isPlaying) RegularPlayer(video: controller.nowPlaying),
                          IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: () => context.readVideoController.stopPlaying(),
                          ),
                        ],
                      )
                    : kEmptyBox,
          ),
        ),
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
        child: Image.asset(video.imgSrc),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () => context.readVideoController.expand(),
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -0.8) {
                  context.readVideoController.expand();
                }
                // print(details.delta);
              },
              child: Image.asset(video.imgSrc, height: kMiniPlayerHeight),
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
