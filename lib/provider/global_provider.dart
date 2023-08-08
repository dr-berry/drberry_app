import 'package:flutter/material.dart';

class GlobalPageProvider extends ChangeNotifier {
  Color _background = const Color(0xFFF9F9F9);
  bool _isMusicBar = true;
  int _musicIdx = 0;
  bool _isPlay = false;
  double _height = 73.0;
  Color get background => _background;
  bool get isMusicBar => _isMusicBar;
  int get musicIdx => _musicIdx;
  bool get isPlay => _isPlay;
  double get height => _height;

  setHeight(double height) {
    _height = height;
    notifyListeners();
  }

  setBackground(Color color) {
    _background = color;
    notifyListeners();
  }

  setIsMusicbar(bool isMusicBar) {
    _isMusicBar = isMusicBar;
    notifyListeners();
  }

  setMusicIdx(int index) {
    _musicIdx = index;
    notifyListeners();
  }

  setIsPlay(bool isPaly) {
    _isPlay = isPaly;
    notifyListeners();
  }
}
