import 'package:flutter/foundation.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/utils/user_preferences.dart';

class UserNotifier extends ChangeNotifier {
  User _user = UserPreferences.myUser;

  User get user => _user;

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
