import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/hive_date_repository.dart';
import 'package:lab1/repositories/hive_network_repository.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';
import 'package:lab1/utils/user_preferences.dart';
import 'package:lab1/widget/home.dart';
import 'package:lab1/widget/login.dart';

class SplashPage extends StatelessWidget {
  final HiveNetworkService networkService;

  const SplashPage({required this.networkService, super.key});

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: HiveAuthRepository().getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          UserPreferences.myUser = user;

          return FutureBuilder<bool>(
            future: checkInternetConnection(),
            builder: (context, connectionSnapshot) {
              if (connectionSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final hasInternet = connectionSnapshot.data ?? false;

              return MyHomePage(
                title: 'Ідеї для побачень',
                ideasRepository: HiveIdeaRepository(),
                offlineMode: !hasInternet,
                networkService: networkService,
              );
            },
          );
        }

        return LoginPage(networkService: networkService);
      },
    );
  }
}
