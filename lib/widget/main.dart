import 'package:flutter/material.dart';
import 'package:lab1/widget/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ідеї для побачень',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF854F6C)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
