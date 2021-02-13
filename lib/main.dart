import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytanim/card.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/custom_stack.dart';
import 'package:ytanim/video_container.dart';
import 'package:ytanim/video_controller.dart';
import 'package:ytanim/video_model.dart';

import 'extensions.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => VideoController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
    );
  }
}

const sampleVideo = Video(
  id: 1,
  thumbnail: 'assets/img/thumb.webp',
  src: 'assets/videos/landspace_360p.mp4',
  title: 'Samsung Galaxy S21 Ultra Review: Problems Solved!',
  published: '5 hours ago',
  views: '20.3k views',
  duration: '1:46',
);

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final hideAppBar = controller.isPlaying && !controller.isMinimized;
    return Scaffold(
      appBar: hideAppBar ? null : AppBar(title: Text('Youtube Demo')),
      body: WillPopScope(
        onWillPop: () async {
          if (controller.isPlaying && !controller.isMinimized) {
            controller.minimize();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: CustomStack(
            children: [
              IgnorePointer(
                ignoring: hideAppBar,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SortDropDown(),
                          VideoCard(video: sampleVideo),
                          VideoCard(video: sampleVideo.withId(2)),
                          VideoCard(video: sampleVideo.withId(3)),
                          VideoCard(video: sampleVideo.withId(4)),
                          VideoCard(video: sampleVideo.withId(5)),
                        ],
                      ),
                    ),
                    SizedBox(height: controller.isMinimized ? kMiniPlayerHeight : 0),
                  ],
                ),
              ),
              // VideoPlayer(),
              AnimatedPositioned(
                bottom: controller.getPosition(context.screenSize),
                duration: k1Second ~/ 3,
                child: VideoContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SortDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.sort),
          SizedBox(width: 8),
          Text('Sort by'),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
