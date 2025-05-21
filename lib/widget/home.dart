import 'package:flutter/material.dart';
import 'package:lab1/widget/profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

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

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
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
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Image.asset(
          _images[_currentIndex],
          fit: BoxFit.cover,
          width: 300,
          height: 300,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextImage,
        tooltip: 'Далі',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
