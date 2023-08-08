import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/Data.dart';

class CalendarPageProvider extends ChangeNotifier {
  Server server = Server();
  int _pageIndex = 0;
  List<Month> _calendar = [];
  String _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  List<History>? _historyList = [];
  List<History>? _weekHistoryList = [];
  List<History>? _monthHistoryList = [];
  int _historyIndex = 0;
  DateTime _selectDate = DateTime.now();
  int get pageIndex => _pageIndex;
  List<Month> get calendar => _calendar;
  String get selectedDate => _selectedDate;
  List<History>? get historyList => _historyList;
  List<History>? get weekHistoryList => _weekHistoryList;
  List<History>? get monthHistoryList => _monthHistoryList;
  int get historyIndex => _historyIndex;
  DateTime get selectDate => _selectDate;

  void setIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void setHistory(int index) {
    _historyIndex = index;
    notifyListeners();
  }

  void setCalendarData(List<Month> calendar) {
    _calendar = calendar;
    notifyListeners();
  }

  void setSelectedDate(int year, int month, int day) async {
    _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime(year, month, day));
    notifyListeners();

    await server.getHistories(_selectedDate).then((value) {
      List<History> result = [];
      List<History> weekResult = [];
      List<History> monthResult = [];

      result.add(History.fromJson(value.data['day']['sleepScore']));
      result.add(History.fromJson(value.data['day']['sleepPattern']));
      result.add(History.fromJson(value.data['day']['wake']));
      result.add(History.fromJson(value.data['day']['heartBeat']));
      result.add(History.fromJson(value.data['day']['toss']));
      result.add(History.fromJson(value.data['day']['snoring']));

      weekResult.add(History.fromJson(value.data['week']['sleepScore']));
      weekResult.add(History.fromJson(value.data['week']['sleepPattern']));
      weekResult.add(History.fromJson(value.data['week']['wake']));
      weekResult.add(History.fromJson(value.data['week']['heartBeat']));
      weekResult.add(History.fromJson(value.data['week']['toss']));
      weekResult.add(History.fromJson(value.data['week']['snoring']));

      monthResult.add(History.fromJson(value.data['month']['sleepScore']));
      monthResult.add(History.fromJson(value.data['month']['sleepPattern']));
      monthResult.add(History.fromJson(value.data['month']['wake']));
      monthResult.add(History.fromJson(value.data['month']['heartBeat']));
      monthResult.add(History.fromJson(value.data['month']['toss']));
      monthResult.add(History.fromJson(value.data['month']['snoring']));

      setHistoryList(result);
      setWeekHistoryList(weekResult);
      setMonthHistoryList(monthResult);
      print("=======");
      print("${result.toString()}, ${weekResult.toString()}, ${monthResult.toString()}");
      print("=======");

      if (result.isEmpty && weekResult.isEmpty && monthResult.isEmpty) {
        setHistoryList(null);
        setWeekHistoryList(null);
        setMonthHistoryList(null);
      } else {
        setHistoryList(result);
        setWeekHistoryList(weekResult);
        setMonthHistoryList(monthResult);
      }
    }).catchError((err) {
      setHistoryList(null);
      setWeekHistoryList(null);
      setMonthHistoryList(null);
    });
  }

  void setHistoryList(List<History>? histories) {
    _historyList = histories;
    notifyListeners();
  }

  void setWeekHistoryList(List<History>? histories) {
    _weekHistoryList = histories;
    notifyListeners();
  }

  void setMonthHistoryList(List<History>? histories) {
    _monthHistoryList = histories;
    notifyListeners();
  }

  void setSelectDate(DateTime date) {
    _selectDate = date;
    notifyListeners();
  }
}
