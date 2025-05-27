import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab1/model/date.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/hive_network_repository.dart';
//import 'package:lab1/repositories/user_preferences.dart';
import 'package:lab1/widget/splash_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final networkService = HiveNetworkService();
  //WidgetsFlutterBinding.ensureInitialized();
  // final networkChecker = ConnectivityChecker();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DateAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Date>('ideas');

  runApp(MyApp(networkService: networkService));
}

class MyApp extends StatelessWidget {
  final HiveNetworkService networkService;

  const MyApp({required this.networkService, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ідеї для побачень',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF854F6C)),
        useMaterial3: true,
      ),
      //home: LoginPage(networkService: networkService),
      home: SplashPage(networkService: networkService),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
