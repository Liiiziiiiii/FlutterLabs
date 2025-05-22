import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';
import 'package:lab1/utils/validators.dart';
//import 'package:lab1/widget/home.dart';
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
  // помічник для виклику async-коду в initState
  // Future.microtask(() async {
  //   await _repo.init();
  //   setState(() { });
  // });
}


  Future<void> _submit(User user) async {
    final ok = await _repo.register(user);

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<LoginPage>(
          builder: (_) => const LoginPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already exists')),
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(hintText: 'Username'),
                validator: (v) =>
                    isValidUsername(v!.trim()) ? null : 'Only letters',
              ),
              const SizedBox(height: 16),
              // Поле для вводу email
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (v) => 
                isValidEmail(v!.trim()) ? null : 'Invalid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (v) => isValidPassword(v!) ? null : 'Min 6 chars',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmCtrl,
                decoration: const InputDecoration(hintText: 'Confirm'),
                obscureText: true,
                validator: (v) =>
                    v == _passwordCtrl.text ? null : 'Passwords differ',
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
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
