import 'package:flutter/material.dart';
import 'package:lab1/providers/login_provider.dart';
import 'package:lab1/repositories/network_repository.dart';

class LoginForm extends StatelessWidget {
  final LoginProvider authProvider;
  final NetworkService networkService;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  LoginForm({
    required this.authProvider,
    required this.networkService,
    super.key,
  });

  Future<void> _submit(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    formState.save();

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    final success = await authProvider.login(email, password);

    if (!context.mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Некоректні дані')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Велкам',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(hintText: 'Пошта'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ведіть пошту' : null,
            ),
            TextFormField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(hintText: 'Пароль'),
              obscureText: true,
              validator: (v) => v == null || v.length < 6
                  ? 'Має бути більше ніж 6 символів'
                  : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: authProvider.isLoading ? null : () => _submit(context),
              child: authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Вхід'),
            ),
          ],
        ),
      ),
    );
  }
}
