import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/hive_network_repository.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';
import 'package:lab1/utils/validators.dart';
import 'package:lab1/widget/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _repo = HiveAuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit(User user) async {
    final ok = await _repo.register(user);
    final networkService = HiveNetworkService();

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<LoginPage>(
          builder: (_) => LoginPage(networkService: networkService),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Акаутна за цією адресоб все існує!')),
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Зареєструватися')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(hintText: 'Ім\'я'),
                validator: (v) =>
                    isValidUsername(v!.trim()) ? null : 'Тільки букви',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(hintText: 'Пошта'),
                validator: (v) =>
                    isValidEmail(v!.trim()) ? null : 'Некоректна пошта',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(hintText: 'Пароль'),
                obscureText: true,
                validator: (v) =>
                    isValidPassword(v!) ? null : 'Менше за 6 символів',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmCtrl,
                decoration: const InputDecoration(hintText: 'Підтвердити'),
                obscureText: true,
                validator: (v) =>
                    v == _passwordCtrl.text ? null : 'Паролі не співпадають',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = User(
                      username: _usernameCtrl.text.trim(),
                      email: _emailCtrl.text.trim(),
                      password: _passwordCtrl.text,
                      photo: '',
                    );
                    _submit(user);
                  }
                },
                child: const Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
