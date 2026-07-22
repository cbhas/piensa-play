import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/datasources/zona_cero/zona_cero_quiz_data.dart';
import '../shared/mission_results_page.dart';

class WordTrailPage extends StatefulWidget {
  const WordTrailPage({super.key});

  @override
  State<WordTrailPage> createState() => _WordTrailPageState();
}

class _WordTrailPageState extends State<WordTrailPage> {
  final questions = ZonaCeroQuizData.wordTrailQuestions;
  int currentIndex = 0;
  int correct = 0;
  int incorrect = 0;

  bool get _english => Localizations.localeOf(context).languageCode == 'en';
  Locale get _locale => Localizations.localeOf(context);

  void _handleAnswer(bool selectsHarmful) {
    final currentQuestion = questions[currentIndex];
    final isCorrect =
        (currentQuestion.correctAnswer ?? false) == selectsHarmful;

    setState(() {
      if (isCorrect) {
        correct++;
      } else {
        incorrect++;
      }
    });

    _showFeedback(isCorrect, currentQuestion.explanation.resolve(_locale));
  }

  void _showFeedback(bool isCorrect, String tip) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: (isCorrect ? AppTheme.accentGreen : Colors.redAccent)
                        .withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_circle : Icons.block,
                    color: isCorrect ? AppTheme.accentGreen : Colors.redAccent,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  isCorrect
                      ? (_english ? 'Correct! Keep going' : '¡Correcto! Sigue así')
                      : (_english
                            ? 'Incorrect, try again'
                            : 'Incorrecto, inténtalo otra vez'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? AppTheme.primaryDark
                        : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  tip,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCorrect
                        ? AppTheme.accentGreen
                        : AppTheme.accentYellow,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _goNext();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    child: Text(
                      _english ? 'Continue' : 'Continuar',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goNext() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      _finishMission();
    }
  }

  Future<void> _finishMission() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => MissionResultsPage(
          correctAnswers: correct,
          incorrectAnswers: incorrect,
          totalQuestions: correct + incorrect,
          missionId: 'mensaje_escondido',
          missionName: 'Zona Cero Odio',
          primaryColor: AppTheme.accentGreen,
          secondaryColor: AppTheme.accentGreen,
          perfectMessage: _english
              ? 'Forest restored!'
              : '¡Bosque restaurado!',
          goodMessage: _english
              ? 'You cleaned up the digital forest'
              : 'Has limpiado el bosque digital',
          tryAgainMessage: _english ? 'Keep practicing!' : '¡Sigue practicando!',
          learningPoints: _english
              ? const [
                  'Words can hurt or help',
                  'Choosing kind phrases makes everyone feel safe',
                  'Respect builds strong communities',
                ]
              : const [
                  'Las palabras pueden herir o ayudar',
                  'Elegir frases amables hace que todos se sientan tranquilos',
                  'El respeto construye comunidades fuertes',
                ],
          showNextButton: false, // Hide next mission button
          onNext: () {
            Navigator.pop(context, 'next');
          },
        ),
      ),
    );

    if (!mounted) return;

    if (result == 'repeat') {
      setState(() {
        currentIndex = 0;
        correct = 0;
        incorrect = 0;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / questions.length;
    final currentQuestion = questions[currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.tertiaryDark,
                AppTheme.secondaryDark,
                Colors.white,
              ],
              stops: [0.0, 0.14, 0.14],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _buildProgress(progress),
                      const SizedBox(height: 14),
                      _buildForestCard(),
                      const SizedBox(height: 14),
                      _buildMissionCard(),
                      const SizedBox(height: 18),
                      _buildPhraseCard(currentQuestion.newsContent.resolve(_locale)),
                      const SizedBox(height: 18),
                      _buildActions(),
                      const SizedBox(height: 14),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Column(
            children: [
              const Text(
                'Zona Cero Odio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _english ? 'The trail of words' : 'El sendero de las palabras',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProgress(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _english ? 'Progress' : 'Progreso',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              Text(
                '${currentIndex + 1}/${questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.accentGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForestCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/map_background.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        height: 150,
      ),
    );
  }

  Widget _buildMissionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F6D0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accentGreen, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppTheme.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _english
                  ? 'Help the forest by deciding if the phrase hurts or helps.'
                  : 'Ayuda al bosque eligiendo si la frase hiere o construye.',
              style: const TextStyle(color: AppTheme.primaryDark, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhraseCard(String phrase) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFEA1D7), Color(0xFF7BCFFF)],
              ),
            ),
            child: const Icon(Icons.format_quote, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            '"$phrase"',
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.primaryDark,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        _buildActionButton(
          label: _english ? 'Hurtful words' : 'Palabra que hiere',
          color: const Color(0xFFF8A8B4),
          textColor: Colors.white,
          onTap: () => _handleAnswer(true),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: _english ? 'Kind words' : 'Palabra que construye',
          color: AppTheme.accentGreen,
          textColor: Colors.white,
          onTap: () => _handleAnswer(false),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
