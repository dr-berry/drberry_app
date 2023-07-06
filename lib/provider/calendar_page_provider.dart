import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:flutter/material.dart';

class CalendarPageProvider extends ChangeNotifier {
  int _pageIndex = 0;
  List<Month> _calendar = [];
  int get pageIndex => _pageIndex;
  List<Month> get calendar => _calendar;

  void setIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void setCalendarData(List<Month> calendar) {
    _calendar = calendar;
    notifyListeners();
  }
}
