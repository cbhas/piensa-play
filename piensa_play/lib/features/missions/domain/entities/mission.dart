import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_question.dart';

class Mission {
  final String id;
  final String title;
  final String subtitle; // Added subtitle
  final String description;
  final bool isCompleted;
  final String iconName;
  final List<QuizQuestion> questions; // Added questions

  Mission({
    required this.id,
    required this.title,
    required this.subtitle, // Required subtitle
    required this.description,
    required this.isCompleted,
    required this.iconName,
    required this.questions, // Required questions
  });
}
