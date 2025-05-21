import 'package:flutter/material.dart';
import 'package:lab1/widget/registration.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_header(context), _inputField(context), _signup(context)],
        ),
      ),
    );
  }

  // Тепер вказуємо, що метод повертає Widget
  Widget _header(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text('Enter your credential to login'),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withAlpha((0.1 * 255).round()),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withAlpha((0.1 * 255).round()),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text('Login', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<SignupPage>(
                builder: (context) => const SignupPage(),
              ),
            );
          },
          child: const Text('Sign Up', style: TextStyle(color: Colors.purple)),
        ),
      ],
    );
  }

  // Якщо розкоментуєш, також вкажи Widget тут:
  // Widget _forgotPassword(BuildContext context) {
  //   return TextButton(
  //     onPressed: () {},
  //     child: const Text(
  //       "Forgot password?",
  //       style: TextStyle(color: Colors.purple),
  //     ),
  //   );
  // }
}
