import 'mission.dart';

class MissionCategory {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String colorHex;
  final List<Mission> missions;
  bool isExpanded;

  MissionCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.colorHex,
    required this.missions,
    this.isExpanded = false,
  });
}
