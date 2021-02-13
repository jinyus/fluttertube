import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/video_model.dart';

class VideoController extends ChangeNotifier {
  bool _minimized = false;
  Video _currentVideoPlaying;
  Chewie _videoWidget;

  List<VideoPlayerController> vC = [];
  List<ChewieController> cC = [];

  Video get nowPlaying => _currentVideoPlaying;

  bool get isPlaying => _currentVideoPlaying != null;

  bool get isMinimized => _minimized;

  bool get isLoading => _videoWidget == null;

  Chewie get videoWidget => _videoWidget;

  Future<void> playVideo(Video video) async {
    _currentVideoPlaying = video;
    _minimized = false;
    _videoWidget = null;
    notifyListeners();

    //dispose current controllers
    cleanUpPrevious();

    final v = VideoPlayerController.asset(video.src);
    await v.initialize();
    final c = ChewieController(
      videoPlayerController: v,
      autoPlay: true,
      looping: true,
      showControls: false,
    );

    vC.add(v);
    cC.add(c);

    _videoWidget = Chewie(
      controller: c,
    );
    notifyListeners();
  }

  void stopPlaying() {
    _currentVideoPlaying = null;
    _minimized = false;
    _videoWidget = null;
    notifyListeners();
    Future.delayed(k1Second, cleanUp);
    // cleanUp();
  }

  void minimize() {
    _minimized = true;
    notifyListeners();
  }

  void maximize() {
    _minimized = false;
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

  double getPosition(Size screenSize) {
    if (_minimized) return -screenSize.height + kMiniPlayerHeight;
    if (isPlaying) return -kStatusBarHeight;
    return -screenSize.height;
  }
}
