import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import 'quiz_question_page.dart';

class QuizIntroPage extends StatelessWidget {
  const QuizIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final english = Localizations.localeOf(context).languageCode == 'en';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          english ? 'Mission: Fake News' : 'Misión: Fake News',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryDark,
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
              AppTheme.accentPink.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(english),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeroSection(size, english),
                      const SizedBox(height: 30),
                      _buildInstructionCards(english),
                      const SizedBox(height: 30),
                      _buildStartButton(context, english),
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

  Widget _buildHeader(bool english) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Veracidadville',
                style: TextStyle(
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
                  color: const Color(0xFFFDD835),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  english ? 'Verify or Fail' : 'Verifica o Falla',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                child: const Icon(
                  Icons.search_rounded,
                  size: 32,
                  color: Colors.white,
                ),
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

  Widget _buildHeroSection(Size size, bool english) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD835).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.track_changes_rounded,
            size: 80,
            color: Colors.black87,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 1500.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
              ),
          const SizedBox(height: 16),
          Text(
            english
                ? 'Become a News Detective!'
                : '¡Conviértete en un Detective de Noticias!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            english
                ? 'Learn to spot false information and protect your city'
                : 'Aprende a identificar información falsa y protege tu ciudad',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
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

  Widget _buildInstructionCards(bool english) {
    final instructions = [
      {
        'icon': Icons.newspaper_rounded,
        'title': english ? 'Read the News' : 'Lee la Noticia',
        'description': english
            ? 'Carefully analyze each article'
            : 'Analiza cuidadosamente cada artículo',
        'color': const Color(0xFF6EC6FF),
      },
      {
        'icon': Icons.search_rounded,
        'title': english ? 'Look for Clues' : 'Busca Pistas',
        'description': english
            ? 'Find suspicious elements'
            : 'Encuentra elementos sospechosos',
        'color': const Color(0xFFA4D65E),
      },
      {
        'icon': Icons.check_circle_rounded,
        'title': english ? 'Select' : 'Selecciona',
        'description': english
            ? 'Mark the false elements'
            : 'Marca los elementos falsos',
        'color': const Color(0xFFE91E63),
      },
    ];

    return Column(
      children: instructions.asMap().entries.map((entry) {
        final index = entry.key;
        final instruction = entry.value;
        return _buildInstructionCard(
          icon: instruction['icon'] as IconData,
          title: instruction['title'] as String,
          description: instruction['description'] as String,
          color: instruction['color'] as Color,
          index: index,
          english: english,
        );
      }).toList(),
    );
  }

  Widget _buildInstructionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int index,
    required bool english,
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
                  child: Icon(icon, size: 32, color: Colors.white),
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
                            english ? 'Step ${index + 1}' : 'Paso ${index + 1}',
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

  Widget _buildStartButton(BuildContext context, bool english) {
    return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.accentPink, Color(0xFFD81B60)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPink.withValues(alpha: 0.5),
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
                    builder: (context) =>
                        const QuizQuestionPage(questionIndex: 0),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    english ? 'Start Mission!' : '¡Comenzar Misión!',
                    style: const TextStyle(
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
