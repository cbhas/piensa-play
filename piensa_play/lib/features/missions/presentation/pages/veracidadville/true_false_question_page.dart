import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../providers/quiz_provider.dart';
import 'true_false_feedback_page.dart';

class TrueFalseQuestionPage extends StatefulWidget {
  const TrueFalseQuestionPage({super.key});

  @override
  State<TrueFalseQuestionPage> createState() => _TrueFalseQuestionPageState();
}

class _TrueFalseQuestionPageState extends State<TrueFalseQuestionPage> {
  @override
  void initState() {
    super.initState();
    // Validate provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final provider = Provider.of<QuizProvider>(context, listen: false);
        final english = Localizations.localeOf(context).languageCode == 'en';
        if (!provider.isValidQuestionIndex(provider.currentQuestionIndex)) {
          _showErrorAndGoBack(
            english
                ? 'Error: invalid question index'
                : 'Error: Índice de pregunta inválido',
          );
        }
      } catch (e) {
        final english = Localizations.localeOf(context).languageCode == 'en';
        _showErrorAndGoBack(
          english
              ? 'Error: provider unavailable'
              : 'Error: Provider no disponible',
        );
      }
    });
  }

  void _showErrorAndGoBack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    Navigator.of(context).pop();
  }

  void _answer(bool userAnswer) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final question = provider.currentQuestion;
    final isCorrect = userAnswer == question.correctAnswer;

    // Register the answer in the provider
    provider.answerQuestion(isCorrect);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrueFalseFeedbackPage(userAnswer: userAnswer, isCorrect: isCorrect),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        final question = provider.currentQuestion;
        final locale = Localizations.localeOf(context);
        final english = locale.languageCode == 'en';
        final progress =
            (provider.currentQuestionIndex + 1) / provider.totalQuestions;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryDark,
                  AppTheme.primaryDark.withValues(alpha: 0.9),
                  Colors.white,
                ],
                stops: const [0.0, 0.25, 0.25],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(progress, english),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildWelcomeCard(english),
                          const SizedBox(height: 20),
                          _buildNewsCard(question, locale, english),
                          const SizedBox(height: 24),
                          _buildCluesCard(question, locale, english),
                          const SizedBox(height: 30),
                          _buildAnswerButtons(english),
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

  Widget _buildHeader(double progress, bool english) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Veracidadville',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      english ? 'Spot Fake News' : 'Detecta Fake News',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDD835),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFDD835).withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  english ? 'NEW!' : '¡NUEVO!',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFDD835),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildWelcomeCard(bool english) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentBlue.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            size: 32,
            color: AppTheme.accentBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              english
                  ? 'Welcome to Veracidadville! Your mission is to spot fake news by analyzing clues like the source, tone, and emotional or exaggerated language.'
                  : '¡Bienvenido a Veracidadville! Tu misión es detectar noticias falsas analizando pistas como la fuente, tono, lenguaje emocional o exagerado.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(delay: 200.ms, begin: 0.2, duration: 400.ms);
  }

  Widget _buildNewsCard(QuizQuestion question, Locale locale, bool english) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with emoji badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFDD835),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smartphone_rounded,
                    size: 24,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.newsAuthor.resolve(locale),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      question.newsDate.resolve(locale),
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // News content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.newsTitle.resolve(locale),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                if (question.newsImage != null)
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            english
                                ? 'Illustrative image'
                                : 'Imagen ilustrativa',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (question.newsImage != null) const SizedBox(height: 16),
                Text(
                  question.newsContent.resolve(locale),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.share,
                        size: 16,
                        color: AppTheme.primaryDark,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        question.newsShares.resolve(locale),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 300.ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildCluesCard(QuizQuestion question, Locale locale, bool english) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentBlue.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.search_rounded,
                size: 28,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(width: 12),
              Text(
                english ? 'CLUES TO SPOT:' : 'PISTAS A DETECTAR:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...?question.clues?.asMap().entries.map((entry) {
            final index = entry.key;
            final clue = entry.value.resolve(locale);
            return _buildClueItem(clue, index);
          }),
        ],
      ),
    ).animate().slideX(delay: 500.ms, begin: 0.2, duration: 400.ms);
  }

  Widget _buildClueItem(String clue, int index) {
    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning, color: Colors.red, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  clue,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: (600 + index * 100).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.1, duration: 300.ms);
  }

  Widget _buildAnswerButtons(bool english) {
    return Row(
      children: [
        Expanded(
          child:
              _buildAnswerButton(
                    label: english ? 'False' : 'Falso',
                    icon: Icons.cancel,
                    color: const Color(0xFFEC407A),
                    answer: false,
                  )
                  .animate(delay: 800.ms)
                  .scale(duration: 400.ms, curve: Curves.easeOutBack),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              _buildAnswerButton(
                    label: english ? 'True' : 'Verdadero',
                    icon: Icons.check_circle,
                    color: const Color(0xFF66BB6A),
                    answer: true,
                  )
                  .animate(delay: 900.ms)
                  .scale(duration: 400.ms, curve: Curves.easeOutBack),
        ),
      ],
    );
  }

  Widget _buildAnswerButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool answer,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _answer(answer),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
