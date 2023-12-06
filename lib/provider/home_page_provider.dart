import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageProvider extends ChangeNotifier {
  MainPageBiometricData? _mainPageBiometricData;
  DateTime _today = DateTime.now();
  String _serverDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String _weekDay = "";
  bool _sleepState = false;

  MainPageBiometricData? get mainPageBiometricData => _mainPageBiometricData;
  DateTime get today => _today;
  String get serverDate => _serverDate;
  String get weekDay => _weekDay;
  bool get sleepState => _sleepState;

  void setMainPageData(MainPageBiometricData mainPageBiometricData) {
    _mainPageBiometricData = mainPageBiometricData;
    notifyListeners();
  }

  void setSleepState(bool sleepState) {
    _sleepState = sleepState;
    notifyListeners();
  }

  void setMultiPageData(MainPageBiometricData mainPageBiometricData, BuildContext context) {
    _mainPageBiometricData = mainPageBiometricData;
    notifyListeners();
    Navigator.pop(context);
  }

  void setDateTime(DateTime value) {
    _today = value;
    notifyListeners();
  }

  Future<void> setServerDate(String date) async {
    _serverDate = date;
    notifyListeners();

    await Server().getMainPage(_serverDate, -1).then((res) {
      print(res.data);

      MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson(res.data);

      setMainPageData(mainPageBiometricData);
    }).catchError((err) => print(err));
  }

  void setWeekDayEnToKo(int weekDay) {
    switch (weekDay) {
      case DateTime.monday:
        _weekDay = "월요일";
        break;
      case DateTime.tuesday:
        _weekDay = "화요일";
        break;
      case DateTime.wednesday:
        _weekDay = "수요일";
        break;
      case DateTime.thursday:
        _weekDay = "목요일";
        break;
      case DateTime.friday:
        _weekDay = "금요일";
        break;
      case DateTime.saturday:
        _weekDay = "토요일";
        break;
      case DateTime.sunday:
        _weekDay = "일요일";
        break;
    }
    notifyListeners();
  }
}
