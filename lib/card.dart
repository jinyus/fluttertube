import 'package:flutter/material.dart';
import 'package:ytanim/video_model.dart';

import 'extensions.dart';

class VideoCard extends StatelessWidget {
  final Video video;

  const VideoCard({Key key, @required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.readVideoController.playVideo(video),
      child: Container(
        margin: EdgeInsets.only(bottom: 8, left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Thumbnail(
                video: video,
              ),
            ),
            SizedBox(width: 12),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Text(video.views, style: TextStyle(fontSize: 12)),
                      SizedBox(width: 8),
                      Text(video.published, style: TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}

class Thumbnail extends StatelessWidget {
  final Video video;

  const Thumbnail({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Center(child: Image.asset(video.thumbnail)),
          Positioned(
            bottom: 0,
            right: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(video.duration, style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
