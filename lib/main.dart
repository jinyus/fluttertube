import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ytanim/card.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/custom_stack.dart';
import 'package:ytanim/sample_data.dart';
import 'package:ytanim/video_container.dart';
import 'package:ytanim/video_controller.dart';

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
      title: 'Flutter Youtube',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    final hideAppBar = controller.isPlaying && !controller.isMinimized;
    return Scaffold(
      appBar: hideAppBar ? null : AppBar(title: Text('Flutter Youtube')),
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
                          ...sampleVideos.map((v) => VideoCard(video: v)).toList(),
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
