import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ytanim/video_controller.dart';

extension ProviderX on BuildContext {
  VideoController get watchVideoController => this.watch<VideoController>();

  VideoController get readVideoController => this.read<VideoController>();

  Size get screenSize => MediaQuery.of(this).size;
}
