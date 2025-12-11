import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/datasources/veracidadville/true_false_quiz_data.dart';
import '../../../domain/entities/veracidadville/true_false_question.dart';
import 'true_false_feedback_page.dart';

class TrueFalseQuestionPage extends StatefulWidget {
  final int questionIndex;

  const TrueFalseQuestionPage({super.key, required this.questionIndex});

  @override
  State<TrueFalseQuestionPage> createState() => _TrueFalseQuestionPageState();
}

class _TrueFalseQuestionPageState extends State<TrueFalseQuestionPage> {
  late TrueFalseQuestion question;
  final List<TrueFalseQuestion> allQuestions = TrueFalseQuizData.getQuestions();

  @override
  void initState() {
    super.initState();
    question = allQuestions[widget.questionIndex];
  }

  void _answer(bool userAnswer) {
    final isCorrect = userAnswer == question.isTrue;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrueFalseFeedbackPage(
          questionIndex: widget.questionIndex,
          userAnswer: userAnswer,
          isCorrect: isCorrect,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.questionIndex + 1) / allQuestions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              AppTheme.primaryDark.withOpacity(0.9),
              Colors.white,
            ],
            stops: const [0.0, 0.25, 0.25],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(progress),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildWelcomeCard(),
                      const SizedBox(height: 20),
                      _buildNewsCard(),
                      const SizedBox(height: 24),
                      _buildCluesCard(),
                      const SizedBox(height: 30),
                      _buildAnswerButtons(),
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

  Widget _buildHeader(double progress) {
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
                    child: const Text(
                      'Detecta Fake News',
                      style: TextStyle(
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
                      color: const Color(0xFFFDD835).withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text('¡NUEVO!', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFDD835),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentBlue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 32)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '¡Bienvenido a Veracidadville! Tu misión es detectar noticias falsas analizando pistas como la fuente, tono, lenguaje emocional o exagerado.',
              style: TextStyle(
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

  Widget _buildNewsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            decoration: BoxDecoration(
              color: const Color(0xFFFDD835),
              borderRadius: const BorderRadius.only(
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
                  child: const Text('📱', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.newsAuthor,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      question.newsDate,
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
                  question.newsTitle,
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
                          const Text('🍋', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 8),
                          Text(
                            '✨ Imagen ilustrativa ✨',
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
                  question.newsContent,
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
                    color: AppTheme.primaryDark.withOpacity(0.1),
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
                        question.newsShares,
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

  Widget _buildCluesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentBlue.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🔍', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
              Text(
                'PISTAS A DETECTAR:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...question.clues.asMap().entries.map((entry) {
            final index = entry.key;
            final clue = entry.value;
            return _buildClueItem(clue, index);
          }).toList(),
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
                  color: Colors.red.withOpacity(0.2),
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

  Widget _buildAnswerButtons() {
    return Row(
      children: [
        Expanded(
          child:
              _buildAnswerButton(
                    label: 'Falso',
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
                    label: 'Verdadero',
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
        gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
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
