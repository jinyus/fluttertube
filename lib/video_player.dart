import 'package:flutter/material.dart';

import 'extensions.dart';

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;
    return AspectRatio(
      aspectRatio: controller.isLoading ? 16 / 9 : controller.aspectRatio,
      child: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.videoWidget,
    );
  }
}
