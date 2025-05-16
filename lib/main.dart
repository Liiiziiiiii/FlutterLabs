import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab1/model/date.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/providers/ideas_notifier.dart';
import 'package:lab1/providers/login_provider.dart';
import 'package:lab1/providers/signup_provider.dart';
import 'package:lab1/providers/user_notifier.dart';
import 'package:lab1/repositories/hive_date_repository.dart';
import 'package:lab1/repositories/hive_network_repository.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';
import 'package:lab1/widget/splash_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final networkService = HiveNetworkService();
  final ideasRepository = HiveIdeaRepository();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DateAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Date>('ideas');

  runApp(
    MultiProvider(
      providers: [
        Provider<HiveNetworkService>.value(value: networkService),
        Provider<HiveIdeaRepository>.value(value: ideasRepository),
        ChangeNotifierProvider<IdeasNotifier>(
          create: (context) => IdeasNotifier(
            ideasRepository: ideasRepository,
            networkService: networkService,
          ),
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (context) => UserNotifier(),
        ),

        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(HiveAuthRepository()),
        ),
        ChangeNotifierProvider<SignupProvider>(
          create: (context) => SignupProvider(HiveAuthRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final networkService = Provider.of<HiveNetworkService>(
      context,
      listen: false,
    );

    return MaterialApp(
      title: 'Ідеї для побачень',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF854F6C)),
        useMaterial3: true,
      ),
      home: SplashPage(networkService: networkService),
    );
  }
}
