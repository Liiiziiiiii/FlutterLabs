//import 'package:lab1/model/date.dart';

abstract class IdeaRepository {
  Future<List<String>> loadIdeas();
  Future<void> addIdea(String idea);
  Future<void> removeIdea(String idea);
}
