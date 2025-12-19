import 'package:flutter/foundation.dart';
import '../../domain/entities/veracidadville/quiz_question.dart';

/// Provider for managing quiz state across questions
/// Tracks current question index, scores, and provides methods for quiz flow
class QuizProvider extends ChangeNotifier {
  final List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;

  QuizProvider({required List<QuizQuestion> questions})
    : _questions = questions {
    if (_questions.isEmpty) {
      throw ArgumentError('Questions list cannot be empty');
    }
  }

  // Getters
  int get currentQuestionIndex => _currentQuestionIndex;
  int get correctAnswers => _correctAnswers;
  int get incorrectAnswers => _incorrectAnswers;
  int get totalQuestions => _questions.length;
  int get totalAnswered => _correctAnswers + _incorrectAnswers;

  QuizQuestion get currentQuestion {
    if (_currentQuestionIndex >= _questions.length) {
      throw RangeError('Question index out of range');
    }
    return _questions[_currentQuestionIndex];
  }

  bool get hasMoreQuestions => _currentQuestionIndex < _questions.length - 1;
  bool get isLastQuestion => _currentQuestionIndex >= _questions.length - 1;

  List<QuizQuestion> get allQuestions => List.unmodifiable(_questions);

  /// Register an answer for the current question
  void answerQuestion(bool isCorrect) {
    if (isCorrect) {
      _correctAnswers++;
    } else {
      _incorrectAnswers++;
    }
    notifyListeners();
  }

  /// Move to the next question
  void nextQuestion() {
    if (hasMoreQuestions) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Reset the quiz to initial state
  void reset() {
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _incorrectAnswers = 0;
    notifyListeners();
  }

  /// Check if a question index is valid
  bool isValidQuestionIndex(int index) {
    return index >= 0 && index < _questions.length;
  }
}
