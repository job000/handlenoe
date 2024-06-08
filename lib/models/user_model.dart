import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  late String _email, _name;

  String get email => _email;
  String get name => _name;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}