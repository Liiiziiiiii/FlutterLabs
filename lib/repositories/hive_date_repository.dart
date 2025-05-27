// import 'package:hive/hive.dart';
// import 'package:lab1/model/date.dart';
import 'package:lab1/repositories/date_repository.dart';

class HiveIdeaRepository implements IdeaRepository {
  final List<String> _ideas = [];

  @override
  Future<List<String>> loadIdeas() async {
    return List.from(_ideas);
  }

  @override
  Future<void> addIdea(String idea) async {
    if (!_ideas.contains(idea)) {
      _ideas.add(idea);
    }
  }

  @override
  Future<void> removeIdea(String idea) async {
    _ideas.remove(idea);
  }
}
