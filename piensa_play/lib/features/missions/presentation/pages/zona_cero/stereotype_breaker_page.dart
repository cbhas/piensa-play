import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/datasources/zona_cero/zona_cero_data.dart';
import '../shared/mission_results_page.dart';

class StereotypeBreakerPage extends StatefulWidget {
  const StereotypeBreakerPage({super.key});

  @override
  State<StereotypeBreakerPage> createState() => _StereotypeBreakerPageState();
}

class _StereotypeBreakerPageState extends State<StereotypeBreakerPage> {
  final scenes = ZonaCeroData.stereotypeScenes();
  late List<bool> fixed;
  int sceneIndex = 0;
  int correctFixes = 0;
  int incorrect = 0;

  int get totalHarmful => scenes
      .map((s) => s.statements.where((st) => !st.isInclusive).length)
      .fold(0, (a, b) => a + b);

  bool get _english => Localizations.localeOf(context).languageCode == 'en';
  Locale get _locale => Localizations.localeOf(context);

  @override
  void initState() {
    super.initState();
    fixed = _buildInitialState();
  }

  List<bool> _buildInitialState() {
    final statements = scenes[sceneIndex].statements;
    return statements.map((s) => s.isInclusive).toList();
  }

  void _toggle(int index) {
    final statement = scenes[sceneIndex].statements[index];
    if (statement.isInclusive) {
      setState(() => incorrect++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _english
                ? 'This message is already inclusive!'
                : '¡Este mensaje ya es inclusivo!',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    if (fixed[index]) return;

    setState(() {
      fixed[index] = true;
      correctFixes++;
    });

    if (fixed.every((e) => e)) {
      _showSceneComplete();
    }
  }

  void _showSceneComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.accentGreen,
                size: 48,
              ),
              const SizedBox(height: 10),
              Text(
                _english ? 'Scene complete!' : '¡Escena lista!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _english
                    ? 'We changed the messages to include everyone.'
                    : 'Cambiamos los mensajes para incluir a todos.',
                style: const TextStyle(color: AppTheme.primaryDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentYellow,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _goNextScene();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    _english ? 'Continue' : 'Continuar',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goNextScene() {
    if (sceneIndex < scenes.length - 1) {
      setState(() {
        sceneIndex++;
        fixed = _buildInitialState();
      });
    } else {
      _finishMission();
    }
  }

  void _finishMission() {
    Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => MissionResultsPage(
          correctAnswers: correctFixes,
          incorrectAnswers: incorrect,
          totalQuestions: correctFixes + incorrect,
          missionId: 'stereotypes',
          missionName: 'Zona Cero Odio',
          primaryColor: const Color(0xFFFFC857),
          secondaryColor: AppTheme.accentGreen,
          perfectMessage: _english
              ? 'Forest restored!'
              : '¡Bosque restaurado!',
          goodMessage: _english
              ? 'You eliminated the stereotypes'
              : 'Has eliminado los estereotipos',
          tryAgainMessage: _english ? 'Keep practicing!' : '¡Sigue practicando!',
          learningPoints: _english
              ? const [
                  'Stereotypes hurt people',
                  'Using words that invite everyone makes the game fair',
                  'Respect and inclusion build strong communities',
                ]
              : const [
                  'Los estereotipos lastiman a las personas',
                  'Usar palabras que invitan a todos hace el juego justo',
                  'El respeto y la inclusión construyen comunidades fuertes',
                ],
        ),
      ),
    ).then((result) {
      if (!mounted) return;
      if (result == 'repeat') {
        setState(() {
          sceneIndex = 0;
          fixed = _buildInitialState();
          correctFixes = 0;
          incorrect = 0;
        });
        return;
      }
      Navigator.pop(context, 'completed');
    });
  }

  @override
  Widget build(BuildContext context) {
    final scene = scenes[sceneIndex];
    final progress = (sceneIndex + 1) / scenes.length;
    final score = totalHarmful == 0
        ? 0
        : ((correctFixes / totalHarmful) * 100).round();

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
              stops: [0.0, 0.1, 0.1],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(progress),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _buildInstructionCard(),
                      const SizedBox(height: 14),
                      _buildSceneCard(scene),
                      const SizedBox(height: 20),
                      _buildScoreCard(score),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
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
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _english ? 'Break stereotypes' : 'Rompe estereotipos',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _english ? 'Progress' : 'Progreso',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${sceneIndex + 1}/${scenes.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
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
          const Icon(Icons.lightbulb, color: AppTheme.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _english
                  ? 'Tap the messages that leave someone out and swap them for options that include everyone.'
                  : 'Toca los mensajes que dejan fuera a alguien y cámbialos por opciones que incluyan a todos.',
              style: const TextStyle(color: AppTheme.primaryDark, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneCard(StereotypeScene scene) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FFF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _english
                ? 'Scene: ${scene.title.resolve(_locale)}'
                : 'Escena: ${scene.title.resolve(_locale)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            scene.description.resolve(_locale),
            style: TextStyle(
              color: AppTheme.primaryDark.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          ...scene.statements.asMap().entries.map((entry) {
            final index = entry.key;
            final statement = entry.value;
            final isFixed = fixed[index];
            final isTarget = !statement.isInclusive;

            return _buildStatementCard(
              statement: statement,
              isFixed: isFixed,
              isTarget: isTarget,
              onTap: () => _toggle(index),
            ).animate().fadeIn(duration: 300.ms, delay: (100 * index).ms);
          }),
        ],
      ),
    );
  }

  Widget _buildStatementCard({
    required StereotypeStatement statement,
    required bool isFixed,
    required bool isTarget,
    required VoidCallback onTap,
  }) {
    final Color borderColor;
    final IconData icon;
    final Color iconColor;
    final Color background;
    final String subtitle;

    if (isFixed) {
      borderColor = Colors.green;
      icon = Icons.check_circle;
      iconColor = Colors.green;
      background = const Color(0xFFE7F7E7);
      subtitle = statement.replacement.resolve(_locale);
    } else if (isTarget) {
      borderColor = Colors.redAccent;
      icon = Icons.warning_amber_rounded;
      iconColor = Colors.redAccent;
      background = const Color(0xFFFFF0F0);
      subtitle = statement.hint.resolve(_locale);
    } else {
      borderColor = Colors.green;
      icon = Icons.check_circle;
      iconColor = Colors.green;
      background = const Color(0xFFE7F7E7);
      subtitle = statement.hint.resolve(_locale);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: 1.5,
            style: isTarget && !isFixed ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statement.text.resolve(_locale),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.primaryDark.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!statement.isInclusive || isFixed)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryDark.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE08C), Color(0xFFFFC857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _english ? 'Score' : 'Puntuación',
                style: const TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _english ? 'Keep it up!' : '¡Sigue así!',
                style: const TextStyle(color: AppTheme.primaryDark, fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _english ? '$score points' : '$score puntos',
                style: const TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
