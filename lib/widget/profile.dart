//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/date_repository.dart';
import 'package:lab1/repositories/hive_network_repository.dart';
import 'package:lab1/repositories/network_repository.dart';
import 'package:lab1/utils/user_preferences.dart';
//import 'package:lab1/widget/appbar_widget.dart';
import 'package:lab1/widget/home.dart';
import 'package:lab1/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  final IdeaRepository ideasRepository;
  const ProfilePage({required this.ideasRepository, super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<String> _savedIdeas = [];
  final NetworkService networkService = HiveNetworkService();

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    final ideas = await widget.ideasRepository.loadIdeas();
    setState(() {
      _savedIdeas = ideas;
    });
  }

  Future<void> _removeIdea(String idea) async {
    await widget.ideasRepository.removeIdea(idea);
    await _loadIdeas();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ідея видалена')));
  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

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
                builder: (context) => MyHomePage(
                  title: 'Головна',
                  ideasRepository: widget.ideasRepository,
                  networkService: networkService,
                ),
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
          buildName(user),
          const SizedBox(height: 24),
          if (_savedIdeas.isEmpty)
            const Center(child: Text('Немає збережених ідей')),
          if (_savedIdeas.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedIdeas.length,
              itemBuilder: (context, index) {
                final imagePath = _savedIdeas[index];
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
                      onPressed: () => _removeIdea(imagePath),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
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
