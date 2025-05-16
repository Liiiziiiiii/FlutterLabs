// widget/signup.dart
import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/providers/signup_provider.dart';
//import 'package:lab1/Providers/auth_provider.dart';
import 'package:lab1/utils/validators.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = User(
                      username: _usernameCtrl.text.trim(),
                      email: _emailCtrl.text.trim(),
                      password: _passwordCtrl.text,
                      photo: '',
                    );

                    final success = await context
                        .read<SignupProvider>()
                        .register(user);

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Акаунт вже існує')),
                      );
                    }
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
