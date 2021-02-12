import 'package:flutter/cupertino.dart';
import 'package:ytanim/const.dart';
import 'package:ytanim/video_model.dart';

class VideoController extends ChangeNotifier {
  bool _minimized = false;
  Video _currentVideoPlaying;

  Video get nowPlaying => _currentVideoPlaying;

  bool get isPlaying => _currentVideoPlaying != null;

  bool get isMinimized => _minimized;

  void playVideo(Video video) {
    _currentVideoPlaying = video;
    _minimized = false;
    notifyListeners();
  }

  void stopPlaying() {
    _currentVideoPlaying = null;
    _minimized = false;
    notifyListeners();
  }

  void minimize() {
    _minimized = true;
    notifyListeners();
  }

  void expand() {
    _minimized = false;
    notifyListeners();
  }

  Size getSize(Size screenSize) {
    if (_minimized) return Size(screenSize.width, kMiniPlayerHeight);
    if (isPlaying) return Size(screenSize.width, screenSize.height);
    return Size(screenSize.width, 0);
  }
}
