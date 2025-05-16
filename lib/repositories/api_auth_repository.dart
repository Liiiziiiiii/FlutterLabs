import 'dart:convert';
// HTTP-based implementation using `http` package
import 'package:http/http.dart' as http;
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/registration_repository.dart';

class ApiAuthRepository implements AuthRepository {
  final _baseUrl = 'http://localhost:5125/api/User';
  String? _token;
  User? _currentUser;

  @override
  Future<bool> register(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.username,
        'email': user.email,
        'password': user.password,
      }),
    );
    return response.statusCode == 201;
  }

  @override
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _token = data['token'] as String?;
      _currentUser = User(
        username: data['username'] as String,
        email: email,
        password: password,
        photo: (data['photo'] as String?) ?? '',
      );
      return _currentUser;
    }
    return null;
  }

  @override
  Future<User?> getCurrentUser() async => _currentUser;

  @override
  Future<void> updateUser(User user) async {
    if (_token == null) return;
    await http.put(
      Uri.parse('$_baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': user.username, 'photo': user.photo}),
    );
    _currentUser = user;
  }

  @override
  Future<void> deleteUser() async {
    if (_token == null) return;
    await http.delete(
      Uri.parse('$_baseUrl/user'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    _currentUser = null;
    _token = null;
  }

  @override
  String? getToken() => _token;
}

// Пример unit-тесту з моками (Mockito)
// test/api_auth_repository_test.dart

/*
import 'package:flutter_test/flutter_test.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/api_auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Генеруємо мок для http.Client
@GenerateMocks([http.Client])
void main() {
  late ApiAuthRepository repo;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    repo = ApiAuthRepository(client: mockClient);
  });

  test('успішна реєстрація повертає true', () async {
    when(mockClient.post(
      Uri.parse('http://localhost:5000/register'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('', 201));

    final result = await repo.register(
    User(username: 'u', email: 'e', password: 'p', photo: ''));
    expect(result, isTrue);
  });

  test('успішний логін повертає User', () async {
    final json = '{"username":"test","token":"abc"}';
    when(mockClient.post(
      Uri.parse('http://localhost:5000/login'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(json, 200));

    final user = await repo.login('e', 'p');
    expect(user, isNotNull);
    expect(repo.getToken(), 'abc');
  });
}
*/
