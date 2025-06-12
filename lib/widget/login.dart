import 'package:flutter/material.dart';
import 'package:lab1/Forms/login_form.dart';
import 'package:lab1/providers/login_provider.dart';
import 'package:lab1/repositories/network_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final NetworkService networkService;

  const LoginPage({required this.networkService, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, LoginProvider auth, _) {
          return FutureBuilder<bool>(
            future: networkService.isConnected(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!) {
                return const Center(
                  child: Text('Немає з’єднання з Інтернетом'),
                );
              }

              return LoginForm(
                // ✅ Must be public
                authProvider: auth,
                networkService: networkService,
              );
            },
          );
        },
      ),
    );
  }
}
