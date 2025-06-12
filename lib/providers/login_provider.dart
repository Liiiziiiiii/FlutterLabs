import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/registration_repository.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository repository;
  User? _currentUser;
  bool _isLoading = false;

  LoginProvider(this.repository);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final user = await repository.login(email, password);

    _isLoading = false;
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await repository.deleteUser();
    _currentUser = null;
    notifyListeners();
  }
}
