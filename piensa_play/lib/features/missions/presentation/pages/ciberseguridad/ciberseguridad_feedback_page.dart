import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../../domain/entities/veracidadville/quiz_element.dart';
import 'ciberseguridad_question_page.dart';
import '../shared/mission_results_page.dart';
import '../../../domain/entities/mission.dart'; // Import Mission entity

class CiberseguridadFeedbackPage extends StatelessWidget {
  final Mission currentMission;
  final int questionIndex;
  final Set<String> selectedElements;
  final bool isCorrect;
  final int totalCorrectAnswers;
  final int totalIncorrectAnswers;

  // Define a list of colors to cycle through for the element cards
  final List<Color> _elementColors = const [
    Color(0xFF6EC6FF), // Light Blue
    Color(0xFFA4D65E), // Light Green
    Color(0xFFFFB74D), // Orange
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
  ];

  const CiberseguridadFeedbackPage({
    super.key,
    required this.currentMission,
    required this.questionIndex,
    required this.selectedElements,
    required this.isCorrect,
    required this.totalCorrectAnswers,
    required this.totalIncorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final questions = currentMission.questions ?? [];
    if (questionIndex >= questions.length || questionIndex < 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MissionResultsPage(
              correctAnswers: totalCorrectAnswers,
              incorrectAnswers: totalIncorrectAnswers,
              totalQuestions: questions.length,
              missionId: currentMission.id, // Use actual mission ID
              missionName: 'Ciberseguridad',
              primaryColor: AppTheme.accentRed,
              secondaryColor: const Color(0xFFFFD93D),
              perfectMessage: '¡Eres un guardián del ciberespacio!',
              goodMessage: 'Has defendido tus datos con éxito',
              tryAgainMessage: '¡Sigue practicando!',
              learningPoints: [
                'No confíes en remitentes desconocidos',
                'Revisa los enlaces antes de hacer clic',
                'Cuidado con las solicitudes urgentes',
              ],
            ),
          ),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = questions[questionIndex];
    final isLastQuestion = questionIndex >= questions.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCorrect
                ? [
                    const Color(0xFF66BB6A),
                    const Color(0xFF4CAF50),
                    const Color(0xFF388E3C),
                  ]
                : [
                    const Color(0xFFEF5350),
                    const Color(0xFFF44336),
                    const Color(0xFFD32F2F),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildResultCard(),
                      const SizedBox(height: 24),
                      _buildNewsCard(question),
                      const SizedBox(height: 24),
                      _buildElementsGrid(question),
                      const SizedBox(height: 30),
                      _buildContinueButton(
                        context,
                        isLastQuestion,
                        questions.length,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Misión Ciberseguridad',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Text(
              isCorrect ? '✅' : '❌',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(isCorrect ? '🎉' : '💪', style: const TextStyle(fontSize: 80))
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 1000.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
              ),
          const SizedBox(height: 20),
          Text(
            isCorrect ? '¡Amenaza Neutralizada!' : '¡Amenaza Detectada!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCorrect
                ? '¡Excelente trabajo protegiendo el ciberespacio!'
                : 'Revisa los elementos marcados y aprende a defenderte mejor',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().scale(
      delay: 200.ms,
      duration: 500.ms,
      curve: Curves.easeOutBack,
    );
  }

  Widget _buildNewsCard(QuizQuestion question) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryDark,
                  AppTheme.primaryDark.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: const Row(
              children: [
                Text('🚨', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'EL MENSAJE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.newsTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.newsContent,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(delay: 400.ms, begin: 0.2, duration: 400.ms);
  }

  Widget _buildElementsGrid(QuizQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Text('🎯', style: TextStyle(fontSize: 24)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Elementos Analizados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: question.elements.asMap().entries.map((entry) {
            final index = entry.key;
            final element = entry.value;
            final wasSelected = selectedElements.contains(element.id);
            final isCorrect = element.isCorrect;

            return _buildFeedbackElementCard(
              element: element,
              wasSelected: wasSelected,
              isCorrect: isCorrect,
              index: index,
              color: _elementColors[index % _elementColors.length],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedbackElementCard({
    required QuizElement element,
    required bool wasSelected,
    required bool isCorrect,
    required int index,
    required Color color,
  }) {
    final showAsCorrect = wasSelected && isCorrect;
    final showAsIncorrect = wasSelected && !isCorrect;
    final showAsMissed = !wasSelected && isCorrect;
    // final showAsNotNeeded = !wasSelected && !isCorrect; // No se usa directamente

    Color cardColor;
    Color borderColor;
    String statusEmoji;
    String statusText;

    if (showAsCorrect) {
      cardColor = const Color(0xFFE8F5E9);
      borderColor = Colors.green;
      statusEmoji = '✅';
      statusText = '¡Correcto!';
    } else if (showAsIncorrect) {
      cardColor = const Color(0xFFFFEBEE);
      borderColor = Colors.red;
      statusEmoji = '❌';
      statusText = 'Incorrecto';
    } else if (showAsMissed) {
      cardColor = const Color(0xFFFFF3E0);
      borderColor = Colors.orange;
      statusEmoji = '⚠️';
      statusText = 'Faltó';
    } else {
      cardColor = Colors.white;
      borderColor = Colors.grey[300]!;
      statusEmoji = '⚪';
      statusText = 'Correcto';
    }

    return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          element.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      element.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: borderColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Text(statusEmoji, style: const TextStyle(fontSize: 24)),
              ),
            ],
          ),
        )
        .animate(delay: (600 + index * 100).ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildContinueButton(
    BuildContext context,
    bool isLastQuestion,
    int totalQuestions,
  ) {
    return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.accentRed, Color(0xFFC62828)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentRed.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isLastQuestion) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MissionResultsPage(
                        correctAnswers: totalCorrectAnswers,
                        incorrectAnswers: totalIncorrectAnswers,
                        totalQuestions: totalQuestions,
                        missionId: currentMission.id,
                        missionName: 'Ciberseguridad',
                        primaryColor: AppTheme.accentRed,
                        secondaryColor: const Color(0xFFFFD93D),
                        perfectMessage: '¡Eres un guardián del ciberespacio!',
                        goodMessage: 'Has defendido tus datos con éxito',
                        tryAgainMessage: '¡Sigue practicando!',
                        learningPoints: [
                          'No confíes en remitentes desconocidos',
                          'Revisa los enlaces antes de hacer clic',
                          'Cuidado con las solicitudes urgentes',
                        ],
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CiberseguridadQuestionPage(
                        currentMission: currentMission,
                        questionIndex: questionIndex + 1,
                        totalCorrectAnswers: totalCorrectAnswers,
                        totalIncorrectAnswers: totalIncorrectAnswers,
                      ),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastQuestion ? 'Ver Resultados' : 'Siguiente Amenaza',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        )
        .animate(delay: 1000.ms)
        .scale(duration: 400.ms, curve: Curves.easeOutBack)
        .then()
        .shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.5));
  }
}
