import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPageProvider extends ChangeNotifier {
  int _pageIndex = 0;
  List<Month> _calendar = [];
  String _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  int get pageIndex => _pageIndex;
  List<Month> get calendar => _calendar;
  String get selectedDate => _selectedDate;

  void setIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void setCalendarData(List<Month> calendar) {
    _calendar = calendar;
    notifyListeners();
  }

  void setSelectedDate(int year, int month, int day) {
    _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime(year, month, day));
    notifyListeners();
  }
}
