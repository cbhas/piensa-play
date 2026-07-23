import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/datasources/veracidadville/veracidadville_quiz_data.dart';
import '../../../domain/entities/veracidadville/quiz_question.dart';
import 'quiz_question_page.dart';
import '../shared/mission_results_page.dart';

class QuizFeedbackPage extends StatelessWidget {
  final int questionIndex;
  final Set<String> selectedElements;
  final bool isCorrect;

  const QuizFeedbackPage({
    super.key,
    required this.questionIndex,
    required this.selectedElements,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final questions = VeracidadvilleQuizData.getQuestions();
    final question = questions[questionIndex];
    final isLastQuestion = questionIndex >= questions.length - 1;
    final locale = Localizations.localeOf(context);
    final english = locale.languageCode == 'en';

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
                      _buildResultCard(english),
                      const SizedBox(height: 24),
                      _buildNewsCard(question, locale, english),
                      const SizedBox(height: 24),
                      _buildElementsGrid(question, english),
                      const SizedBox(height: 30),
                      _buildContinueButton(context, isLastQuestion, english),
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
            'Veracidadville',
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
            child: Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildResultCard(bool english) {
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
          Icon(
                isCorrect
                    ? Icons.celebration_rounded
                    : Icons.thumb_up_rounded,
                size: 80,
                color: isCorrect ? Colors.green : Colors.orange,
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 1000.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
              ),
          const SizedBox(height: 20),
          Text(
            isCorrect
                ? (english ? 'Correct!' : '¡Correcto!')
                : (english ? 'So close!' : '¡Casi lo logras!'),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCorrect
                ? (english
                      ? 'Great job spotting the false information!'
                      : '¡Excelente trabajo detectando la información falsa!')
                : (english
                      ? 'Review the marked elements and learn from your mistakes'
                      : 'Revisa los elementos marcados y aprende de tus errores'),
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

  Widget _buildNewsCard(QuizQuestion question, Locale locale, bool english) {
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
            child: Row(
              children: [
                const Icon(
                  Icons.newspaper_rounded,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    english ? 'THE NEWS' : 'LA NOTICIA',
                    style: const TextStyle(
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
                  question.newsTitle.resolve(locale),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.newsContent.resolve(locale),
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

  Widget _buildElementsGrid(QuizQuestion question, bool english) {
    final elementData = [
      {
        'id': 'author',
        'icon': Icons.person_rounded,
        'title': english ? 'Author' : 'Autor',
        'color': const Color(0xFF6EC6FF),
      },
      {
        'id': 'source',
        'icon': Icons.link_rounded,
        'title': english ? 'Source' : 'Fuente',
        'color': const Color(0xFFA4D65E),
      },
      {
        'id': 'image',
        'icon': Icons.image_rounded,
        'title': english ? 'Image' : 'Imagen',
        'color': const Color(0xFFFFB74D),
      },
      {
        'id': 'data',
        'icon': Icons.bar_chart_rounded,
        'title': english ? 'Data' : 'Datos',
        'color': const Color(0xFFE91E63),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                size: 24,
                color: Colors.black87,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  english ? 'Elements Analyzed' : 'Elementos Analizados',
                  style: const TextStyle(
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
          children: elementData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final element = question.elements.firstWhere(
              (e) => e.id == data['id'],
            );
            final wasSelected = selectedElements.contains(element.id);
            final isCorrect = element.isCorrect;

            return _buildFeedbackElementCard(
              icon: data['icon'] as IconData,
              title: data['title'] as String,
              color: data['color'] as Color,
              wasSelected: wasSelected,
              isCorrect: isCorrect,
              index: index,
              english: english,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedbackElementCard({
    required IconData icon,
    required String title,
    required Color color,
    required bool wasSelected,
    required bool isCorrect,
    required int index,
    required bool english,
  }) {
    // Determine the state
    final showAsCorrect = wasSelected && isCorrect;
    final showAsIncorrect = wasSelected && !isCorrect;
    final showAsMissed = !wasSelected && isCorrect;

    Color cardColor;
    Color borderColor;
    IconData statusIcon;
    String statusText;

    if (showAsCorrect) {
      cardColor = const Color(0xFFE8F5E9);
      borderColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
      statusText = english ? 'Correct!' : '¡Correcto!';
    } else if (showAsIncorrect) {
      cardColor = const Color(0xFFFFEBEE);
      borderColor = Colors.red;
      statusIcon = Icons.cancel_rounded;
      statusText = english ? 'Incorrect' : 'Incorrecto';
    } else if (showAsMissed) {
      cardColor = const Color(0xFFFFF3E0);
      borderColor = Colors.orange;
      statusIcon = Icons.warning_amber_rounded;
      statusText = english ? 'Missed' : 'Faltó';
    } else {
      cardColor = Colors.white;
      borderColor = Colors.grey[300]!;
      statusIcon = Icons.radio_button_unchecked_rounded;
      statusText = english ? 'Correct' : 'Correcto';
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
                        child: Icon(icon, size: 32, color: color),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
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
                child: Icon(statusIcon, size: 24, color: borderColor),
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
    bool english,
  ) {
    return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFDD835).withValues(alpha: 0.5),
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
                        correctAnswers: 3,
                        incorrectAnswers: 0,
                        totalQuestions: 3,
                        missionId: 'fake_news',
                        missionName: 'Veracidadville',
                        primaryColor: const Color(0xFFFDD835),
                        secondaryColor: AppTheme.accentGreen,
                        perfectMessage: english
                            ? 'You are a master detective!'
                            : '¡Eres un maestro detective!',
                        goodMessage: english
                            ? 'You protected Veracidadville'
                            : 'Has protegido Veracidadville',
                        tryAgainMessage: english
                            ? 'Keep practicing!'
                            : '¡Sigue practicando!',
                        learningPoints: english
                            ? const [
                                'Always verify the source of information',
                                'Be wary of very emotional language',
                                'Magic promises are usually false',
                              ]
                            : const [
                                'Verifica siempre la fuente de información',
                                'Desconfía de lenguaje muy emocional',
                                'Las promesas mágicas suelen ser falsas',
                              ],
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizQuestionPage(questionIndex: questionIndex + 1),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastQuestion
                        ? (english ? 'See Results' : 'Ver Resultados')
                        : (english ? 'Next Question' : 'Siguiente Pregunta'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, color: Colors.black87),
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
