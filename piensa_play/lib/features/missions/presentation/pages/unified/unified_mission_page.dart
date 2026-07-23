import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/services/audio_service.dart';
import '../../../domain/entities/mission.dart';
import '../../../domain/entities/mission_category.dart';
import '../../../domain/entities/unified_question.dart';
import '../../widgets/mission_progress_bar.dart';
import '../../widgets/mission_feedback_overlay.dart';
import '../../widgets/question_types/quiz_question_widget.dart';
import '../../widgets/question_types/true_false_widget.dart';
import '../../widgets/question_types/word_selection_widget.dart';
import '../../widgets/question_types/classify_widget.dart';
import '../../widgets/question_types/fill_blank_widget.dart';
import '../../widgets/question_types/match_pairs_widget.dart';
import '../shared/mission_results_page.dart';
import 'explanation_page.dart';

/// Página unificada para todas las misiones
/// Maneja el flujo: Intro -> Preguntas -> Feedback -> Resultados
class UnifiedMissionPage extends StatefulWidget {
  final Mission mission;
  final MissionCategory category;
  final List<UnifiedQuestion> questions;

  const UnifiedMissionPage({
    super.key,
    required this.mission,
    required this.category,
    required this.questions,
  });

  @override
  State<UnifiedMissionPage> createState() => _UnifiedMissionPageState();
}

class _UnifiedMissionPageState extends State<UnifiedMissionPage> {
  // Estados
  bool _showIntro = true;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  bool _showFeedback = false;
  bool _lastAnswerCorrect = false;

  // Estados de selección (ahora soporta múltiples)
  Set<String> _selectedOptionIds = {};
  bool? _selectedBoolAnswer;
  Set<String> _selectedWords = {};
  Map<String, String> _userClassification = {}; // Para classify
  List<String> _userBlanks = []; // Para fillBlank
  Map<String, String> _userMatches = {}; // Para matchPairs

  List<UnifiedQuestion> get questions => widget.questions;
  UnifiedQuestion get currentQuestion => questions[_currentQuestionIndex];
  bool get isLastQuestion => _currentQuestionIndex >= questions.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal
          SafeArea(
            child: _showIntro ? _buildIntroScreen() : _buildQuestionScreen(),
          ),

          // Panel de feedback (aparece desde abajo)
          if (_showFeedback)
            MissionFeedbackOverlay(
              isCorrect: _lastAnswerCorrect,
              explanation: _lastAnswerCorrect
                  ? currentQuestion.explanation
                  : (currentQuestion.incorrectExplanation ??
                        currentQuestion.explanation),
              onContinue: _onFeedbackContinue,
              onExplain: _onShowExplanation,
            ),
        ],
      ),
    );
  }

  /// Pantalla de introducción a la misión (diseño limpio)
  Widget _buildIntroScreen() {
    final categoryColor = _getCategoryColor();

    return Container(
      decoration: const BoxDecoration(
        // Fondo neutro claro para mejor legibilidad
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA), // Gris muy claro
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Header compacto con acento de color
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 16,
              left: 8,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: categoryColor),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.category.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Ícono circular con borde de color de categoría
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: categoryColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _getMissionIcon(),
                        size: 60,
                        color: categoryColor,
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 28),

                  // Título de la misión
                  Text(
                    widget.mission.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 12),

                  // Descripción
                  Text(
                    widget.mission.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 32),

                  // Card de información con borde de color
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Número de preguntas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.quiz_outlined,
                              color: categoryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${questions.length} preguntas',
                              style: TextStyle(
                                color: AppTheme.primaryDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Tip
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: categoryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getTipForMission(),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 40),

                  // Botón comenzar con color de categoría
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startMission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: categoryColor.withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        '¡Comenzar!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Obtener color de la categoría
  Color _getCategoryColor() {
    // Intentar parsear el color de la categoría
    try {
      final colorStr = widget.category.colorHex;
      if (colorStr.isNotEmpty) {
        // Quitar # si existe y agregar 0xFF para opacidad
        String hex = colorStr.replaceAll('#', '').replaceAll('0x', '');
        if (hex.length == 6) {
          return Color(int.parse('0xFF$hex'));
        } else if (hex.length == 8) {
          return Color(int.parse('0x$hex'));
        }
      }
    } catch (_) {}
    // Fallback a verde vibrante (no azul)
    return AppTheme.accentGreen;
  }

  /// Obtener tip según el tipo de misión
  String _getTipForMission() {
    final questionTypes = questions.map((q) => q.type).toSet();
    if (questionTypes.contains(QuestionType.quiz)) {
      return 'Puedes seleccionar múltiples respuestas antes de verificar';
    } else if (questionTypes.contains(QuestionType.trueFalse)) {
      return 'Analiza la información cuidadosamente antes de responder';
    } else if (questionTypes.contains(QuestionType.wordSelection)) {
      return 'Selecciona todas las palabras que consideres correctas';
    }
    return 'Lee cada pregunta con atención antes de responder';
  }

  /// Pantalla de pregunta
  Widget _buildQuestionScreen() {
    return Container(
      color: AppTheme.backgroundLight,
      child: Column(
        children: [
          // Header consistente con tertiaryDark
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 12,
              left: 8,
              right: 8,
            ),
            decoration: const BoxDecoration(color: AppTheme.tertiaryDark),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _showExitDialog,
                ),
                Expanded(
                  child: Text(
                    widget.mission.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 48), // Balance
              ],
            ),
          ),

          // Barra de progreso
          MissionProgressBar(
            currentQuestion: _currentQuestionIndex,
            totalQuestions: questions.length,
            correctAnswers: _correctAnswers,
            incorrectAnswers: _incorrectAnswers,
          ),

          // Contenido de la pregunta
          Expanded(child: _buildQuestionContent()),
        ],
      ),
    );
  }

  /// Renderiza el widget de pregunta según el tipo
  Widget _buildQuestionContent() {
    switch (currentQuestion.type) {
      case QuestionType.quiz:
        return QuizQuestionWidget(
          question: currentQuestion,
          onAnswer: _onOptionToggle,
          isAnswered: _showFeedback,
          selectedOptionIds: _selectedOptionIds,
          onVerify: _onVerifyQuiz,
        );

      case QuestionType.trueFalse:
        return TrueFalseWidget(
          question: currentQuestion,
          onAnswer: _onBoolSelected,
          isAnswered: _showFeedback,
          selectedAnswer: _selectedBoolAnswer,
          onVerify: _onVerifyTrueFalse,
        );

      case QuestionType.wordSelection:
        return WordSelectionWidget(
          question: currentQuestion,
          onAnswer: _onWordToggle,
          isAnswered: _showFeedback,
          selectedWords: _selectedWords,
          onVerify: _onVerifyWords,
        );

      case QuestionType.stereotype:
        // Por ahora usa el mismo widget que quiz
        return QuizQuestionWidget(
          question: currentQuestion,
          onAnswer: _onOptionToggle,
          isAnswered: _showFeedback,
          selectedOptionIds: _selectedOptionIds,
          onVerify: _onVerifyQuiz,
        );

      case QuestionType.classify:
        return ClassifyWidget(
          question: currentQuestion,
          isAnswered: _showFeedback,
          userClassification: _userClassification,
          onItemClassified: _onItemClassified,
          onVerify: _onVerifyClassify,
        );

      case QuestionType.fillBlank:
        return FillBlankWidget(
          question: currentQuestion,
          isAnswered: _showFeedback,
          userAnswers: _userBlanks,
          onWordPlaced: _onWordPlaced,
          onVerify: _onVerifyFillBlank,
        );

      case QuestionType.matchPairs:
        return MatchPairsWidget(
          question: currentQuestion,
          isAnswered: _showFeedback,
          userMatches: _userMatches,
          onMatch: _onMatch,
          onVerify: _onVerifyMatchPairs,
        );
    }
  }

  void _startMission() {
    HapticFeedback.mediumImpact(); // Feedback al iniciar
    setState(() {
      _showIntro = false;
    });
  }

  /// Obtener las opciones seleccionadas actualmente
  /// Toggle selección de opción (para quiz múltiple)
  void _onOptionToggle(bool isCorrect, String? optionId) {
    if (optionId == null) return;
    setState(() {
      if (_selectedOptionIds.contains(optionId)) {
        _selectedOptionIds.remove(optionId);
      } else {
        _selectedOptionIds.add(optionId);
      }
    });
  }

  /// Selección de respuesta booleana
  void _onBoolSelected(bool isCorrect, String? optionId) {
    setState(() {
      _selectedBoolAnswer = optionId == 'true';
    });
  }

  /// Toggle selección de palabra
  void _onWordToggle(bool isCorrect, String? optionId) {
    final word = currentQuestion.options
        .firstWhere(
          (o) => o.id == optionId,
          orElse: () => const AnswerOption(id: '', text: '', isCorrect: false),
        )
        .text;

    setState(() {
      if (_selectedWords.contains(word)) {
        _selectedWords.remove(word);
      } else {
        _selectedWords.add(word);
      }
    });
  }

  /// Verificar respuesta de quiz
  void _onVerifyQuiz() {
    // Calcular si es correcto: todas las correctas seleccionadas Y ninguna incorrecta
    final correctOptions = currentQuestion.options
        .where((o) => o.isCorrect)
        .map((o) => o.id)
        .toSet();
    final selectedCorrect = _selectedOptionIds.intersection(correctOptions);
    final selectedIncorrect = _selectedOptionIds.difference(correctOptions);

    final isCorrect =
        selectedCorrect.length == correctOptions.length &&
        selectedIncorrect.isEmpty;

    _showAnswerFeedback(isCorrect);
  }

  /// Verificar respuesta true/false
  void _onVerifyTrueFalse() {
    final isCorrect = currentQuestion.correctBoolAnswer == _selectedBoolAnswer;
    _showAnswerFeedback(isCorrect);
  }

  /// Verificar respuesta de palabras
  void _onVerifyWords() {
    final correctWords = currentQuestion.options
        .where((o) => o.isCorrect)
        .map((o) => o.text)
        .toSet();
    final isCorrect =
        _selectedWords.containsAll(correctWords) &&
        correctWords.containsAll(_selectedWords);
    _showAnswerFeedback(isCorrect);
  }

  /// Clasificar un item en una categoría
  void _onItemClassified(String itemId, String category) {
    setState(() {
      if (category.isEmpty) {
        // Remover de la clasificación
        _userClassification.remove(itemId);
      } else {
        // Agregar a la categoría
        _userClassification[itemId] = category;
      }
    });
  }

  /// Verificar clasificación
  void _onVerifyClassify() {
    final isCorrect = currentQuestion.isClassificationCorrect(
      _userClassification,
    );
    _showAnswerFeedback(isCorrect);
  }

  /// Colocar palabra en un espacio en blanco
  void _onWordPlaced(int blankIndex, String word) {
    setState(() {
      // Asegurar que la lista sea lo suficientemente grande
      while (_userBlanks.length <= blankIndex) {
        _userBlanks.add('');
      }
      _userBlanks[blankIndex] = word;
    });
  }

  /// Verificar espacios en blanco
  void _onVerifyFillBlank() {
    final isCorrect = currentQuestion.areBlanksCorrect(_userBlanks);
    _showAnswerFeedback(isCorrect);
  }

  /// Conectar pareja (left -> right)
  void _onMatch(String left, String right) {
    setState(() {
      if (right.isEmpty) {
        // Deshacer match
        _userMatches.remove(left);
      } else {
        _userMatches[left] = right;
      }
    });
  }

  /// Verificar parejas
  void _onVerifyMatchPairs() {
    final isCorrect = currentQuestion.areMatchesCorrect(_userMatches);
    _showAnswerFeedback(isCorrect);
  }

  /// Mostrar feedback de respuesta
  void _showAnswerFeedback(bool isCorrect) {
    // Reproducir sonido de acierto o error
    if (isCorrect) {
      AudioService().playCorrect();
    } else {
      AudioService().playIncorrect();
    }

    setState(() {
      _lastAnswerCorrect = isCorrect;
      _showFeedback = true;
      if (isCorrect) {
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
      }
    });
  }

  void _onFeedbackContinue() {
    HapticFeedback.lightImpact(); // Feedback al continuar
    if (isLastQuestion) {
      _finishMission();
    } else {
      setState(() {
        _currentQuestionIndex++;
        _showFeedback = false;
        _selectedOptionIds = {};
        _selectedBoolAnswer = null;
        _selectedWords = {};
        _userClassification = {};
        _userBlanks = [];
        _userMatches = {};
      });
    }
  }

  /// Mostrar página de explicación detallada
  void _onShowExplanation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExplanationPage(
          isCorrect: _lastAnswerCorrect,
          questionTitle: currentQuestion.title,
          explanation: _lastAnswerCorrect
              ? currentQuestion.explanation
              : (currentQuestion.incorrectExplanation ??
                    currentQuestion.explanation),
          onContinue: _onFeedbackContinue,
        ),
      ),
    );
  }

  Future<void> _finishMission() async {
    if (!mounted) return;

    // Ir a página de resultados (MissionResultsPage maneja la gamificación y badges)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MissionResultsPage(
          correctAnswers: _correctAnswers,
          incorrectAnswers: _incorrectAnswers,
          totalQuestions: questions.length,
          missionId: widget.mission.id,
          missionName: widget.mission.title,
          primaryColor: AppTheme.primaryDark,
          secondaryColor: AppTheme.accentBlue,
          perfectMessage:
              '¡Excelente! Eres un experto en detectar información.',
          goodMessage: '¡Buen trabajo! Sigue practicando.',
          tryAgainMessage: 'No te preocupes, ¡inténtalo de nuevo!',
          learningPoints: [
            'Verifica siempre la fuente de la información',
            'Busca señales de desinformación',
            'Comparte solo información verificada',
          ],
          mission: widget.mission,
          category: widget.category,
        ),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, 'completed');
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir de la misión?'),
        content: const Text('Perderás tu progreso actual.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar dialog
              Navigator.pop(context); // Salir de misión
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  IconData _getMissionIcon() {
    switch (widget.mission.type) {
      case MissionType.quiz:
        return Icons.newspaper_rounded;
      case MissionType.trueFalse:
        return Icons.fact_check_rounded;
      case MissionType.wordSelection:
        return Icons.text_fields_rounded;
      case MissionType.stereotype:
        return Icons.theater_comedy_rounded;
    }
  }
}
