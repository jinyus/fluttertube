import 'package:flutter/material.dart';
import 'package:fluttertube/card.dart';
import 'package:fluttertube/const.dart';
import 'package:fluttertube/pages/video_page/video_page.dart';
import 'package:fluttertube/sample_data.dart';
import 'package:fluttertube/video_controller.dart';
import 'package:provider/provider.dart';

import 'extensions.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => VideoController(),
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
        toggleableActiveColor: Colors.lightBlue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final controller = context.watchVideoController;
    final onVideoPage = controller.hasVideo && !controller.isMinimized;
    return Scaffold(
      appBar: onVideoPage ? null : AppBar(title: Text('Flutter Youtube')),
      body: WillPopScope(
        onWillPop: () async {
          if (onVideoPage) {
            //if user presses back button when on the video page, minimize the player instead of
            //popping the route.
            controller.minimize();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SortDropDown(),
                        ...sampleVideos.map((v) => VideoCard(video: v)).toList(),
                      ],
                    ),
                  ),
                  //this is done to push up the bottom of the video list so the last
                  //video can be seen.
                  SizedBox(height: controller.isMinimized ? kMiniPlayerHeight : 0),
                ],
              ),
              AnimatedPositioned(
                curve: Curves.easeOutCirc,
                bottom: controller.getPosition(
                  context.screenSize,
                  statusBarHeight: statusBarHeight,
                ),
                duration: k1Second,
                child: VideoPage(),
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
