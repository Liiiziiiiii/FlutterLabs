import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/providers/ideas_notifier.dart';
import 'package:lab1/providers/user_notifier.dart';
//import 'package:lab1/utils/user_preferences.dart';
import 'package:lab1/widget/home.dart';
import 'package:lab1/widget/profile_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = UserPreferences.myUser;
    // final ideasNotifier = context.watch<IdeasNotifier>();
    final user = context.watch<UserNotifier>().user;
    final ideasNotifier = context.watch<IdeasNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: const Color(0xFFDFB6B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Повернутися на головну',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<MyHomePage>(
                builder: (_) => const MyHomePage(title: 'Головна'),
              ),
            );
          },
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(imagePath: user.photo, onClicked: () async {}),
          const SizedBox(height: 24),
          _buildName(user),
          const SizedBox(height: 24),
          if (ideasNotifier.savedIdeas.isEmpty)
            const Center(child: Text('Немає збережених ідей')),
          if (ideasNotifier.savedIdeas.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ideasNotifier.savedIdeas.length,
              itemBuilder: (context, index) {
                final imagePath = ideasNotifier.savedIdeas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.asset(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await ideasNotifier.removeIdea(imagePath);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ідея видалена')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildName(User user) => Column(
    children: [
      Text(
        user.username,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(user.email, style: const TextStyle(color: Colors.grey)),
    ],
  );
}
