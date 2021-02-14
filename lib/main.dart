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
    final hideAppBar = controller.hasVideo && !controller.isMinimized;
    return Scaffold(
      appBar: hideAppBar ? null : AppBar(title: Text('Flutter Youtube')),
      body: WillPopScope(
        onWillPop: () async {
          if (controller.hasVideo && !controller.isMinimized) {
            //if user presses back button when on the video page, minimize the player instead of
            //popping the route.
            controller.minimize();
            return false;
          }
          return true;
        },
        child: SafeArea(
          //Custom stack is used because only the top most child receives touch input
          //with the normal stack. The custom stack sends input events to all children widgets.
          //This is needed because The user should be able to scroll the video list and pause/stop
          //the video on the mini-player.
          child: CustomStack(
            children: [
              IgnorePointer(
                //since the player is on top of the video list and the custom stack sends touch
                //events to all its children, the video list would receive touch events when interacting
                //with the video page. So this will ensure that the video list ignore touch events when
                //the AppBar is hidden and the appbar is only hidden when the user is on the video page.
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
                    //this is done to push up the bottom of the video list so it doesn't
                    //receive touch events when interacting with the mini-player.
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
