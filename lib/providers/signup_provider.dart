import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';

class SignupProvider extends ChangeNotifier {
  final HiveAuthRepository _repo;

  SignupProvider(this._repo);

  Future<bool> register(User user) async {
    return await _repo.register(user);
  }
}
