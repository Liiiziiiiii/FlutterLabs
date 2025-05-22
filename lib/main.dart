import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab1/model/date.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/widget/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DateAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Date>('ideas');

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
