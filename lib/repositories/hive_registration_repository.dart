// lib/repositories/hive_registration_repository.dart
import 'package:hive/hive.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/registration_repository.dart';

class HiveAuthRepository implements AuthRepository {
  //static const _boxName = 'users';
  //late Box<User> _box;
  final _box = Hive.box<User>('users');

  @override
  Future<bool> register(User user) async {
    if (_box.values.any((u) => u.email == user.email)) return false;
    await _box.put(user.email, user);
    return true;
  }

  @override
  Future<User?> login(String email, String password) async {
    final user = _box.get(email);
    if (user != null && user.password == password) {
      return user;
    }

    return null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _box.values.isEmpty ? null : _box.values.first;
  }

  @override
  Future<void> updateUser(User user) => user.save();

  @override
  Future<void> deleteUser() async => _box.clear();
}
