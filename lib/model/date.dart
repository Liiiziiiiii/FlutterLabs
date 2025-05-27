import 'package:hive/hive.dart';

part 'date.g.dart';

@HiveType(typeId: 1)
class Date extends HiveObject {
  @HiveField(0)
  String imagePath;

  @HiveField(1)
  String title;

  Date({required this.imagePath, required this.title});
}
