import 'package:flutter/material.dart';

class MainPageProvider extends ChangeNotifier {
  int _pageIndex = 0;
  Color _appBarColor = const Color(0xFFF9F9F9);
  int get pageIndx => _pageIndex;
  Color get appBarColor => _appBarColor;

  void setIndex(int pageIndex) {
    _pageIndex = pageIndex;
    notifyListeners();
  }

  void setAppBarColor(Color color) {
    _appBarColor = color;
    notifyListeners();
  }
}
