import 'package:flutter/material.dart';
import 'package:lab1/providers/ideas_notifier.dart';
import 'package:lab1/widget/appbar_widget.dart';
import 'package:lab1/widget/buttons.dart';
import 'package:lab1/widget/login.dart';
import 'package:lab1/widget/profile.dart';
import 'package:lab1/widget/qr_scanner_screen.dart';
import 'package:lab1/widget/sensor.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final ideasNotifier = context.watch<IdeasNotifier>();
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.3;

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
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<LoginPage>(
                  builder: (_) =>
                      LoginPage(networkService: ideasNotifier.networkService),
                ),
                (_) => false,
              );
            }
          }
        },
        onProfilePressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(builder: (context) => const ProfilePage()),
          );
        },
        onButtonPressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(builder: (context) => const Buttons()),
          );
        },
        onQrPressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const QRScannerScreen(),
            ),
          );
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              ideasNotifier.images[ideasNotifier.currentIndex],
              fit: BoxFit.cover,
              width: imageSize,
              height: imageSize,
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: ideasNotifier.isOfflineMode
                ? 'Недоступно в автономному режимі'
                : 'Додати ідею',
            iconSize: size.width * 0.1,
            onPressed: ideasNotifier.isOfflineMode
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Збереження ідей недоступне'),
                      ),
                    );
                  }
                : () async {
                    final message = await ideasNotifier.saveCurrentIdea();
                    if (message != null && context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    }
                  },
          ),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ideasNotifier.nextImage,
        tooltip: 'Далі',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
