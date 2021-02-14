import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/const.dart';
import 'package:fluttertube/video_model.dart';
import 'package:video_player/video_player.dart';

//todo: keep last 3 videos in memory so the user can navigate back to previous videos

final _iosControls = CupertinoControls(
  backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
  iconColor: Color.fromARGB(255, 200, 200, 200),
);

class VideoController extends ChangeNotifier {
  bool _minimized = false;
  Video _currentVideoPlaying;
  Widget _videoWidget;
  VideoPlayer _miniplayerWidget;
  bool _miniplayerPaused = false;
  double statusBarHeight;

  List<VideoPlayerController> vC = [];
  List<ChewieController> cC = [];

  Video get nowPlaying => _currentVideoPlaying;

  bool get hasVideo => _currentVideoPlaying != null;

  bool get isMinimized => _minimized;

  bool get isLoading => _videoWidget == null;

  bool get miniplayerPaused => _miniplayerPaused;

  Widget get videoWidget => _minimized ? _miniplayerWidget : _videoWidget;

  double get aspectRatio => vC.first.value.aspectRatio;

  Future<void> playVideo(Video video) async {
    _currentVideoPlaying = video;
    _minimized = false;
    _videoWidget = null;
    _miniplayerWidget = null;
    notifyListeners();

    //dispose current controllers
    cleanUpPrevious();

    final v = VideoPlayerController.asset(video.src);
    await v.initialize();
    final c = ChewieController(
      videoPlayerController: v,
      autoPlay: true,
      looping: true,
      customControls: _iosControls,
    );
    await c.setVolume(0);

    vC.add(v);
    cC.add(c);

    _videoWidget = Chewie(
      controller: c,
    );

    _miniplayerWidget = VideoPlayer(v);
    notifyListeners();
  }

  void stopPlaying() {
    _currentVideoPlaying = null;
    _minimized = false;
    _videoWidget = null;
    _miniplayerWidget = null;
    notifyListeners();
    Future.delayed(k1Second, cleanUp);
  }

  void minimize() {
    _minimized = true;
    _miniplayerPaused = !cC.first.isPlaying;
    notifyListeners();
  }

  void maximize() {
    _minimized = false;
    notifyListeners();
  }

  void toggleMiniPlayerPause() {
    _miniplayerPaused = !_miniplayerPaused;
    if (_miniplayerPaused) {
      cC.first.pause();
    } else {
      cC.first.play();
    }
    notifyListeners();
  }

  void cleanUpPrevious() {
    if (cC.isEmpty) return;
    final prevVC = vC.first;
    final prevCC = cC.first;
    vC.clear();
    cC.clear();
    Future.delayed(k1Second, () {
      prevVC.dispose();
      prevCC.dispose();
    });
  }

  void cleanUp() {
    vC.forEach((c) => c.dispose());
    cC.forEach((c) => c.dispose());
    vC.clear();
    cC.clear();
  }

  double getPosition(Size screenSize, {double statusBarHeight}) {
    this.statusBarHeight ??= statusBarHeight;
    if (_minimized) return -screenSize.height + kMiniPlayerHeight + statusBarHeight;
    if (hasVideo) return 0;
    return -screenSize.height;
  }
}
