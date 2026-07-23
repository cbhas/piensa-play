import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../providers/quiz_provider.dart';
import 'true_false_question_page.dart';
import '../shared/mission_results_page.dart';

class TrueFalseFeedbackPage extends StatelessWidget {
  final bool userAnswer;
  final bool isCorrect;

  const TrueFalseFeedbackPage({
    super.key,
    required this.userAnswer,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        final question = provider.currentQuestion;
        final isLastQuestion = provider.isLastQuestion;
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
                          _buildExplanationCard(question, locale, english),
                          const SizedBox(height: 30),
                          _buildContinueButton(
                            context,
                            isLastQuestion,
                            provider,
                            english,
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
      },
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
                isCorrect ? Icons.celebration_rounded : Icons.thumb_up_rounded,
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
                      ? 'Great job spotting the truth!'
                      : '¡Excelente trabajo detectando la verdad!')
                : (english
                      ? 'Review the clues to improve'
                      : 'Revisa las pistas para mejorar'),
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

  Widget _buildExplanationCard(
    QuizQuestion question,
    Locale locale,
    bool english,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentBlue, Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  english ? 'Explanation' : 'Explicación',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (question.correctAnswer ?? false)
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (question.correctAnswer ?? false)
                    ? Colors.green
                    : Colors.red,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  (question.correctAnswer ?? false)
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: (question.correctAnswer ?? false)
                      ? Colors.green
                      : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    english
                        ? 'This news is ${(question.correctAnswer ?? false) ? "TRUE" : "FALSE"}'
                        : 'Esta noticia es ${(question.correctAnswer ?? false) ? "VERDADERA" : "FALSA"}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (question.correctAnswer ?? false)
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            english ? 'The key clues were:' : 'Las pistas clave eran:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...?question.clues?.asMap().entries.map((entry) {
            final index = entry.key;
            final clue = entry.value.resolve(locale);
            return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppTheme.accentGreen,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          clue,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: (400 + index * 100).ms)
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.1, duration: 300.ms);
          }),
        ],
      ),
    ).animate().slideY(delay: 400.ms, begin: 0.2, duration: 400.ms);
  }

  Widget _buildContinueButton(
    BuildContext context,
    bool isLastQuestion,
    QuizProvider provider,
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
                        correctAnswers: provider.correctAnswers,
                        incorrectAnswers: provider.incorrectAnswers,
                        totalQuestions: provider.totalQuestions,
                        missionId: 'titular',
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
                  // Move to next question
                  provider.nextQuestion();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrueFalseQuestionPage(),
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
