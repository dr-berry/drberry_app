import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  String _name = "";
  String _birth = "";
  int _tall = 0;
  int _weight = 0;
  String _gender = "";
  bool _disabled = false;
  int _frag = 0;

  String get name => _name;
  String get birth => _birth;
  int get tall => _tall;
  int get weight => _weight;
  String get gender => _gender;
  bool get disabled => _disabled;
  int get frag => _frag;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setBirth(String birth) {
    _birth = birth;
    notifyListeners();
  }

  void setTall(int tall) {
    _tall = tall;
    notifyListeners();
  }

  void setWeight(int weight) {
    _weight = weight;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setDisabled(bool disabled) {
    _disabled = disabled;
    notifyListeners();
  }

  void setFrag(int frag) {
    _frag = frag;
    notifyListeners();
  }
}
