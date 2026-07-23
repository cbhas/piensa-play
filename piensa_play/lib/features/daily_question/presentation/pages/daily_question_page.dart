import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/core/services/audio_service.dart';
import 'package:piensa_play/core/services/daily_question_service.dart';
import 'package:piensa_play/features/missions/domain/entities/unified_question.dart';
import 'package:piensa_play/features/missions/presentation/widgets/question_types/quiz_question_widget.dart';
import 'package:piensa_play/features/missions/presentation/widgets/question_types/true_false_widget.dart';
import 'package:piensa_play/features/missions/presentation/widgets/question_types/word_selection_widget.dart';
import 'package:piensa_play/features/missions/presentation/widgets/question_types/classify_widget.dart';
import 'package:piensa_play/features/missions/presentation/widgets/question_types/fill_blank_widget.dart';
import 'package:piensa_play/features/missions/presentation/widgets/question_types/match_pairs_widget.dart';
import 'package:piensa_play/features/missions/presentation/widgets/mission_feedback_overlay.dart';

/// Página para la pregunta diaria
/// Usa el mismo flujo de feedback que las misiones
class DailyQuestionPage extends StatefulWidget {
  final UnifiedQuestion question;

  const DailyQuestionPage({super.key, required this.question});

  @override
  State<DailyQuestionPage> createState() => _DailyQuestionPageState();
}

class _DailyQuestionPageState extends State<DailyQuestionPage> {
  final DailyQuestionService _dailyService = DailyQuestionService();
  final AudioService _audioService = AudioService();

  bool _showFeedback = false;
  bool _isCorrect = false;
  Map<String, int>? _rewards;

  // Estados de respuesta según tipo
  final Set<String> _selectedOptionIds = {};
  bool? _selectedBoolAnswer;
  final Set<String> _selectedWords = {};
  final Map<String, String> _userClassification = {};
  final List<String> _userBlanks = [];
  final Map<String, String> _userMatches = {};

  bool get _english => Localizations.localeOf(context).languageCode == 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),
                // Contenido de la pregunta
                Expanded(child: _buildQuestionContent()),
              ],
            ),
            // Overlay de feedback (popup desde abajo con confeti)
            if (_showFeedback)
              MissionFeedbackOverlay(
                isCorrect: _isCorrect,
                explanation: widget.question.explanation,
                onContinue: _onContinue,
                onExplain: _showExplanation,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.accentYellow,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.tertiaryDark),
            onPressed: () => _showExitDialog(),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _english ? 'Question of the day!' : '¡Pregunta del día!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.tertiaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_rewards != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+${_rewards!['xp']} XP  •  +${_rewards!['coins']}',
                        style: TextStyle(
                          color: AppTheme.tertiaryDark.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.monetization_on_rounded,
                        size: 14,
                        color: AppTheme.tertiaryDark.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    switch (widget.question.type) {
      case QuestionType.quiz:
        return QuizQuestionWidget(
          question: widget.question,
          onAnswer: (bool _, String? optionId) {
            if (optionId != null) _onToggleOption(optionId);
          },
          isAnswered: _showFeedback,
          selectedOptionIds: _selectedOptionIds,
          onVerify: _onVerifyQuiz,
        );

      case QuestionType.trueFalse:
        return TrueFalseWidget(
          question: widget.question,
          selectedAnswer: _selectedBoolAnswer,
          isAnswered: _showFeedback,
          onAnswer: (bool _, String? answer) {
            if (answer != null) {
              setState(() {
                _selectedBoolAnswer = answer == 'true';
              });
            }
          },
          onVerify: _onVerifyTrueFalse,
        );

      case QuestionType.wordSelection:
        return WordSelectionWidget(
          question: widget.question,
          onAnswer: (bool _, String? word) {
            if (word != null) _onWordToggle(word);
          },
          selectedWords: _selectedWords,
          isAnswered: _showFeedback,
          onVerify: _onVerifyWords,
        );

      case QuestionType.classify:
        return ClassifyWidget(
          question: widget.question,
          isAnswered: _showFeedback,
          userClassification: _userClassification,
          onItemClassified: _onItemClassified,
          onVerify: _onVerifyClassify,
        );

      case QuestionType.fillBlank:
        return FillBlankWidget(
          question: widget.question,
          isAnswered: _showFeedback,
          userAnswers: _userBlanks,
          onWordPlaced: _onWordPlaced,
          onVerify: _onVerifyFillBlank,
        );

      case QuestionType.matchPairs:
        return MatchPairsWidget(
          question: widget.question,
          isAnswered: _showFeedback,
          userMatches: _userMatches,
          onMatch: _onMatch,
          onVerify: _onVerifyMatchPairs,
        );

      case QuestionType.stereotype:
        return QuizQuestionWidget(
          question: widget.question,
          onAnswer: (bool _, String? optionId) {
            if (optionId != null) _onToggleOption(optionId);
          },
          isAnswered: _showFeedback,
          selectedOptionIds: _selectedOptionIds,
          onVerify: _onVerifyQuiz,
        );
    }
  }

  // Callbacks de respuesta
  void _onToggleOption(String optionId) {
    if (_showFeedback) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedOptionIds.contains(optionId)) {
        _selectedOptionIds.remove(optionId);
      } else {
        _selectedOptionIds.add(optionId);
      }
    });
  }

  void _onVerifyQuiz() {
    final correctOptions = widget.question.options
        .where((o) => o.isCorrect)
        .map((o) => o.id)
        .toSet();
    final selectedCorrect = _selectedOptionIds.intersection(correctOptions);
    final selectedIncorrect = _selectedOptionIds.difference(correctOptions);

    final isCorrect =
        selectedCorrect.length == correctOptions.length &&
        selectedIncorrect.isEmpty;

    _submitAnswer(isCorrect);
  }

  void _onVerifyTrueFalse() {
    if (_selectedBoolAnswer == null) return;
    final isCorrect = widget.question.correctBoolAnswer == _selectedBoolAnswer;
    _submitAnswer(isCorrect);
  }

  void _onWordToggle(String word) {
    if (_showFeedback) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedWords.contains(word)) {
        _selectedWords.remove(word);
      } else {
        _selectedWords.add(word);
      }
    });
  }

  void _onVerifyWords() {
    final correctWords = widget.question.options
        .where((o) => o.isCorrect)
        .map((o) => o.text)
        .toSet();
    final isCorrect =
        _selectedWords.length == correctWords.length &&
        _selectedWords.every((w) => correctWords.contains(w));
    _submitAnswer(isCorrect);
  }

  void _onItemClassified(String itemId, String category) {
    setState(() {
      if (category.isEmpty) {
        _userClassification.remove(itemId);
      } else {
        _userClassification[itemId] = category;
      }
    });
  }

  void _onVerifyClassify() {
    final isCorrect = widget.question.isClassificationCorrect(
      _userClassification,
    );
    _submitAnswer(isCorrect);
  }

  void _onWordPlaced(int blankIndex, String word) {
    setState(() {
      while (_userBlanks.length <= blankIndex) {
        _userBlanks.add('');
      }
      _userBlanks[blankIndex] = word;
    });
  }

  void _onVerifyFillBlank() {
    final isCorrect = widget.question.areBlanksCorrect(_userBlanks);
    _submitAnswer(isCorrect);
  }

  void _onMatch(String left, String right) {
    setState(() {
      if (right.isEmpty) {
        _userMatches.remove(left);
      } else {
        _userMatches[left] = right;
      }
    });
  }

  void _onVerifyMatchPairs() {
    final isCorrect = widget.question.areMatchesCorrect(_userMatches);
    _submitAnswer(isCorrect);
  }

  Future<void> _submitAnswer(bool isCorrect) async {
    HapticFeedback.mediumImpact();

    // Reproducir sonido
    if (isCorrect) {
      _audioService.playCorrect();
    } else {
      _audioService.playIncorrect();
    }

    // Mostrar feedback INMEDIATAMENTE (sin esperar Firebase)
    setState(() {
      _showFeedback = true;
      _isCorrect = isCorrect;
    });

    // Registrar respuesta en background (no bloquea UI)
    _dailyService.submitAnswer(isCorrect).then((rewards) {
      if (mounted) {
        setState(() => _rewards = rewards);
      }
    });
  }

  void _onContinue() {
    Navigator.of(context).pop(true);
  }

  void _showExplanation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  size: 28,
                  color: AppTheme.accentYellowAlt,
                ),
                const SizedBox(width: 12),
                Text(
                  _isCorrect
                      ? (_english
                            ? 'Why is it correct?'
                            : '¿Por qué es correcto?')
                      : (_english ? 'Explanation' : 'Explicación'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.question.explanation,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _english ? 'Got it' : 'Entendido',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_english ? 'Leave?' : '¿Salir?'),
        content: Text(
          _english
              ? 'If you leave now you will lose the chance to answer today\'s question.'
              : 'Si sales ahora, perderás la oportunidad de responder la pregunta del día.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_english ? 'Stay' : 'Seguir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, false);
            },
            child: Text(_english ? 'Leave' : 'Salir'),
          ),
        ],
      ),
    );
  }
}
