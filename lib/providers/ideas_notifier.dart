import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab1/repositories/date_repository.dart';
import 'package:lab1/repositories/network_repository.dart';

class IdeasNotifier extends ChangeNotifier {
  final IdeaRepository ideasRepository;
  final NetworkService networkService;

  final List<String> _images = [
    'assets/images/foto1.jpg',
    'assets/images/foto2.jpg',
    'assets/images/foto3.jpg',
    'assets/images/foto4.jpg',
  ];

  int _currentIndex = 0;
  List<String> _savedIdeas = [];
  bool _hasConnection = true;
  bool _isOfflineMode = false;

  StreamSubscription<bool>? _networkSubscription;

  IdeasNotifier({required this.ideasRepository, required this.networkService}) {
    _networkSubscription = networkService.onNetworkStatusChange.listen(
      _onNetworkChanged,
    );
    _loadIdeas();
  }

  List<String> get images => _images;
  int get currentIndex => _currentIndex;
  List<String> get savedIdeas => _savedIdeas;
  bool get hasConnection => _hasConnection;
  bool get isOfflineMode => _isOfflineMode;

  void _onNetworkChanged(bool connected) {
    _hasConnection = connected;
    _isOfflineMode = !connected;
    notifyListeners();
  }

  Future<void> removeIdea(String imagePath) async {
    await ideasRepository.removeIdea(imagePath);
    await _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    _savedIdeas = await ideasRepository.loadIdeas();
    notifyListeners();
  }

  void nextImage() {
    _currentIndex = (_currentIndex + 1) % _images.length;
    notifyListeners();
  }

  Future<String?> saveCurrentIdea() async {
    final currentImage = _images[_currentIndex];
    if (!_savedIdeas.contains(currentImage)) {
      await ideasRepository.addIdea(currentImage);
      await _loadIdeas();
      return 'Ідея додана до профілю';
    } else {
      return 'Ідея вже збережена';
    }
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }
}
