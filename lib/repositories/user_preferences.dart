import 'package:lab1/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyEmail = 'user_email';
  static User? myUser;
  
  static Future<void> saveUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
  }
}
