import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab1/repositories/date_repository.dart';
//import 'package:lab1/repositories/hive_network_repository.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';
import 'package:lab1/repositories/network_repository.dart';
import 'package:lab1/widget/appbar_widget.dart';
//import 'package:lab1/utils/user_preferences.dart';
import 'package:lab1/widget/login.dart';
import 'package:lab1/widget/profile.dart';
import 'package:lab1/widget/sensor.dart';

class MyHomePage extends StatefulWidget {
  final IdeaRepository ideasRepository;
  final NetworkService networkService;
  final bool offlineMode;

  const MyHomePage({
    required this.title,
    required this.ideasRepository,
    required this.networkService,
    super.key,
    this.offlineMode = false,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool get offlineMode => widget.offlineMode;

  final List<String> _images = [
    'assets/images/foto1.jpg',
    'assets/images/foto2.jpg',
    'assets/images/foto3.jpg',
    'assets/images/foto4.jpg',
  ];

  int _currentIndex = 0;
  List<String> _savedIdeas = [];
  StreamSubscription<bool>? networkSubscription;
  bool hasConnection = true;
  late final NetworkService networkService;
  // final networkService = HiveNetworkService();

  @override
  void dispose() {
    networkSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    networkService = widget.networkService;
    networkSubscription = networkService.onNetworkStatusChange.listen((
      connected,
    ) {
      setState(() => hasConnection = connected);

      if (!connected && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Втрачено з’єднання з Інтернетом')),
        );
      }
    });
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    final ideas = await widget.ideasRepository.loadIdeas();
    setState(() {
      _savedIdeas = ideas;
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  Future<void> _saveIdea() async {
    final currentImage = _images[_currentIndex];
    if (!_savedIdeas.contains(currentImage)) {
      await widget.ideasRepository.addIdea(currentImage);
      await _loadIdeas();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ідея додана до профілю')));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ідея вже збережена')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (offlineMode) {
      return const Scaffold(
        body: Center(
          child: Text('Ви в автономному режимі. Частина функцій вимкнена.'),
        ),
      );
    }
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        onSensorPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<SensorPage>(
              builder: (context) => const SensorPage(),
            ),
          );
        },
        onLogoutPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Підтвердження'),
              content: const Text('Ви впевнені, що хочете вийти?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Скасувати'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Так'),
                ),
              ],
            ),
          );

          if (shouldLogout == true) {
            await HiveAuthRepository().deleteUser();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<LoginPage>(
                  builder: (_) => LoginPage(networkService: networkService),
                ),
                (_) => false,
              );
            }
          }
        },
        onProfilePressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) =>
                  ProfilePage(ideasRepository: widget.ideasRepository),
            ),
          ).then((_) => _loadIdeas());
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              _images[_currentIndex],
              fit: BoxFit.cover,
              width: 300,
              height: 300,
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Додати ідею',
            iconSize: 40,
            onPressed: _saveIdea,
          ),

          // IconButton(
          //   icon: const Icon(Icons.sensors),
          //   tooltip: 'Сенсори',
          //   onPressed: () {
          //     Navigator.push<void>(
          //       context,
          //       MaterialPageRoute<void>(
          //         builder: (context) => const SensorPage(),
          //       ),
          //     );
          //   },
          // ),
          const SizedBox(height: 16),
          // ElevatedButton(
          //   child: const Text('Вийти'),
          //   onPressed: () async {
          //     final shouldLogout = await showDialog<bool>(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         title: const Text('Підтвердження'),
          //         content: const Text('Ви впевнені, що хочете вийти?'),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, false),
          //             child: const Text('Скасувати'),
          //           ),
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, true),
          //             child: const Text('Так'),
          //           ),
          //         ],
          //       ),
          //     );

          //     if (shouldLogout == true) {
          //       await HiveAuthRepository().deleteUser(); // очищення сесії
          //       //UserPreferences.myUser = null;
          //       if (context.mounted) {
          //         Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute<LoginPage>(
          //             builder: (_) => const LoginPage(),
          //           ),
          //           (_) => false,
          //         );
          //       }
          //     }
          //   },
          // ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _nextImage,
        tooltip: 'Далі',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
