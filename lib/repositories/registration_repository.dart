// lib/repositories/registration_repository.dart
import 'package:lab1/model/user.dart';

abstract class AuthRepository {
 // Future<void> init();                    
  Future<bool> register(User user);       
  Future<User?> login(String email, String password);
  Future<User?> getCurrentUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser();
}
