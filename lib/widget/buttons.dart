import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _Buttons();
}

class _Buttons extends State<Buttons> {
  int counter = 0;

  void _increaseCounter() {
    if (counter >= 100) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Забагато')));
      return;
    }
    setState(() {
      counter += 8;
    });
  }

  void _decreaseCounter() {
    if (counter <= -10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Замало')));
      return;
    }
    setState(() {
      counter -= 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лічильник')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Значення: $counter', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _increaseCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 59, 234, 11),
              ),
              child: const Text('Збільшити на 8'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _decreaseCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 44, 16),
              ),
              child: const Text('Зменшити на 5'),
            ),
          ],
        ),
      ),
    );
  }
}
