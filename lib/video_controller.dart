import 'dart:math';

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
    _position = null;
    _firstOffset = null;
    notifyListeners();
  }

  void maximize() {
    _minimized = false;
    _position = null;
    _firstOffset = null;
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

  double _firstOffset;
  double _position;
  double _minimizePosition;

  void maximizeDragUpdate(double offset) {
    if (!_minimized) return;

    //assign a starting point when user starts dragging
    _firstOffset ??= offset;

    final addend = _firstOffset - offset;

    _position = _minimizePosition + addend;

    // print('base $_minimizePosition pos $_position');

    //video dragged up 50px from the minimized Position, so maximize
    if (_position - _minimizePosition >= 50) return maximize();

    //make sure it's not dragged off screen
    _position = max(_minimizePosition, _position);

    notifyListeners();
  }

  void minimizeDragUpdate(double offset) {
    if (_minimized) return;

    _firstOffset ??= offset;

    _position = _firstOffset - offset;

    //if video is dragged 100px from the top, so minimize
    if (_position <= -100) return minimize();

    _position = min(0, _position);
    notifyListeners();
  }

  void minimizeEnded(double velocity) {
    //if user flicks video faster than 1000px/s then minimize
    if (velocity > 1000) return minimize();

    //video already minimized
    if (_position == null) return;

    //if video wasn't dragged far enough, cancel minimizing (should bounce back to top)
    if (_position > -100) {
      _position = null;
      _firstOffset = null;
      notifyListeners();
    }
  }

  void maximizeEnded(double velocity) {
    if (velocity > 1000) return maximize();

    if (_position == null) return;

    if (_position - _minimizePosition < 50) {
      _position = null;
      _firstOffset = null;
      notifyListeners();
    }
  }

  double getPosition(Size screenSize, {double statusBarHeight}) {
    this.statusBarHeight ??= statusBarHeight;
    if (_position != null) return _position;

    _minimizePosition ??= -screenSize.height + kMiniPlayerHeight + statusBarHeight;

    if (_minimized) return _minimizePosition;
    if (hasVideo) return 0;
    return -screenSize.height;
  }
}
