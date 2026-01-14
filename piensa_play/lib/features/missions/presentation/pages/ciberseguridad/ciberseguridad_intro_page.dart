import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import 'ciberseguridad_question_page.dart'; // Actualizado para la nueva estructura
import '../../../domain/entities/mission.dart'; // Import Mission entity
import '../../../data/datasources/ciberseguridad/ciberseguridad_quiz_data.dart'; // Import CiberseguridadQuizData

class CiberseguridadIntroPage extends StatelessWidget {
  final Mission currentMission; // Add currentMission

  const CiberseguridadIntroPage({
    super.key,
    required this.currentMission,
  }); // Update constructor

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          currentMission.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.accentRed,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryDark,
              AppTheme.primaryDark.withValues(alpha: 0.8),
              AppTheme.accentRed.withValues(alpha: 0.3), // Usando accentRed
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
                      _buildHeroSection(size),
                      const SizedBox(height: 30),
                      _buildInstructionCards(),
                      const SizedBox(height: 30),
                      _buildStartButton(context),
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentMission.title, // Use currentMission title
                style: const TextStyle(
                  fontSize: 28,
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
                  color: const Color(0xFFFF6B6B), // Color principal sugerido
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentMission.subtitle, // Use currentMission subtitle
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '🛡️',
                  style: TextStyle(fontSize: 32),
                ), // Emoji principal sugerido
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 2000.ms,
                color: Colors.white.withValues(alpha: 0.3),
              ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildHeroSection(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)], // Colores sugeridos
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFFF6B6B,
            ).withValues(alpha: 0.4), // Color principal sugerido
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('💻', style: TextStyle(fontSize: 80)) // Emoji relevante
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 1500.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
              ),
          const SizedBox(height: 16),
          Text(
            currentMission.title, // Use currentMission title
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            currentMission.description, // Use currentMission description
            style: const TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _buildInstructionCards() {
    return Column(
      children: CiberseguridadQuizData.instructions.asMap().entries.map((
        entry,
      ) {
        final index = entry.key;
        final instruction = CiberseguridadQuizData.instructions[index];
        return _buildInstructionCard(
          emoji: _getInstructionEmoji(index),
          title: _getInstructionTitle(index),
          description: instruction,
          color: _getInstructionColor(index),
          index: index,
        );
      }).toList(),
    );
  }

  String _getInstructionEmoji(int index) {
    switch (index) {
      case 0:
        return '📧';
      case 1:
        return '🤔';
      case 2:
        return '🚩';
      default:
        return '💡';
    }
  }

  String _getInstructionTitle(int index) {
    switch (index) {
      case 0:
        return 'Analiza el Mensaje';
      case 1:
        return 'Busca Señales';
      case 2:
        return 'Marca el Peligro';
      default:
        return 'Instrucción';
    }
  }

  Color _getInstructionColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF6EC6FF);
      case 1:
        return const Color(0xFFA4D65E);
      case 2:
        return const Color(0xFFE91E63);
      default:
        return AppTheme.accentRed;
    }
  }

  Widget _buildInstructionCard({
    required String emoji,
    required String title,
    required String description,
    required Color color,
    required int index,
  }) {
    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Paso ${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (300 + index * 100).ms)
        .slideX(begin: 0.3, duration: 400.ms, curve: Curves.easeOut)
        .fadeIn();
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppTheme.accentRed,
                Color(0xFFC62828),
              ], // Usando accentRed
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentRed.withValues(
                  alpha: 0.5,
                ), // Usando accentRed
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CiberseguridadQuestionPage(
                      currentMission: currentMission, // Pass currentMission
                      questionIndex: 0,
                      totalCorrectAnswers: 0,
                      totalIncorrectAnswers: 0,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¡Iniciar Defensa!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: 800.ms)
        .scale(duration: 400.ms, curve: Curves.easeOutBack)
        .then()
        .shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.3));
  }
}
