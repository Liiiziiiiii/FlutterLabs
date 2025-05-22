import 'package:flutter/material.dart';
import 'package:lab1/repositories/date_repository.dart';
import 'package:lab1/widget/profile.dart';

class MyHomePage extends StatefulWidget {
  final IdeaRepository ideasRepository;
  const MyHomePage({
    required this.title,
    required this.ideasRepository,
    super.key,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _images = [
    'assets/images/foto1.jpg',
    'assets/images/foto2.jpg',
    'assets/images/foto3.jpg',
    'assets/images/foto4.jpg',
  ];

  int _currentIndex = 0;
  List<String> _savedIdeas = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFDFB6B2),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Профіль',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      ProfilePage(ideasRepository: widget.ideasRepository),
                ),
              ).then((_) => _loadIdeas());
            },
          ),
        ],
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
