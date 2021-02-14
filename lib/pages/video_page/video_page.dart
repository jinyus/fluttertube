import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/card.dart';
import 'package:fluttertube/const.dart';
import 'package:fluttertube/extensions.dart';
import 'package:fluttertube/sample_data.dart';
import 'package:fluttertube/video_model.dart';
import 'package:fluttertube/video_player.dart';

part 'action_bar.dart';
part 'info_box.dart';
part 'mini_player.dart';
part 'regular_player.dart';

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watchVideoController;

    if (!controller.hasVideo) return _FullSizedContainer();

    return _FullSizedContainer(
      child: controller.isMinimized ? const _MiniPlayer() : const _RegularPlayer(),
    );
  }
}

class _FullSizedContainer extends StatelessWidget {
  final Widget child;

  const _FullSizedContainer({Key key, this.child}) : super(key: key);

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
