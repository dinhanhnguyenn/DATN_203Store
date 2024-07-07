import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _userId = 0;

  UserProvider(this._userId);

  int get userId => _userId;

  void setUserId(int newUserId) {
    _userId = newUserId;
    notifyListeners();
  }

  void logout() {
    _userId = 0;
    notifyListeners();
  }
}
