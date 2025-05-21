import 'package:flutter/material.dart';

void main() {
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
      home: const MyHomePage(title: 'Ідеї для побачень'),
    );
  }
}

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
