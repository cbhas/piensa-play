import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/services/mission_progress_service.dart';
import '../../../../../core/services/gamification_service.dart';
import '../../../../../core/services/user_id_provider.dart';
import '../../../../achievements/presentation/widgets/badge_unlock_dialog.dart';
import '../../../domain/entities/mission.dart';
import '../../../domain/entities/mission_category.dart';
import '../../../data/repositories/missions_repository.dart';

/// Unified results page for all missions
/// Replaces: QuizResultsPage, CiberseguridadResultsPage, ZonaCeroResultPage
class MissionResultsPage extends StatefulWidget {
  // Results data
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalQuestions;

  // Mission configuration
  final String missionId; // Mission ID for progress tracking
  final String missionName;
  final Color primaryColor;
  final Color secondaryColor;
  final String perfectMessage;
  final String goodMessage;
  final String tryAgainMessage;
  final List<String> learningPoints;

  // Optional customization
  final String? backgroundImage;
  final bool showNextButton;
  final String nextButtonLabel;
  final VoidCallback? onNext;

  // Gamification - optional, si se proporcionan se dará XP/monedas/badges
  final Mission? mission;
  final MissionCategory? category;

  const MissionResultsPage({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalQuestions,
    required this.missionId, // Required for tracking
    required this.missionName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.perfectMessage,
    required this.goodMessage,
    required this.tryAgainMessage,
    required this.learningPoints,
    this.backgroundImage,
    this.showNextButton = false,
    this.nextButtonLabel = 'Siguiente Misión',
    this.onNext,
    this.mission,
    this.category,
  });

  @override
  State<MissionResultsPage> createState() => _MissionResultsPageState();
}

class _MissionResultsPageState extends State<MissionResultsPage> {
  final _progressService = MissionProgressService();
  final _gamificationService = GamificationService();
  final _missionsRepository = MissionsRepository();

  @override
  void initState() {
    super.initState();
    // Mark mission as completed and process gamification
    _completeMission();
  }

  Future<void> _completeMission() async {
    // Marcar misión como completada
    await _progressService.completeMission(widget.missionId);

    Mission? mission = widget.mission;
    MissionCategory? category = widget.category;

    // Si no se proporcionaron, buscar en el repositorio
    if (mission == null || category == null) {
      try {
        final userId = UserIdProvider.currentUserId;
        final categories = await _missionsRepository.getMissionCategories(
          userId,
        );
        for (final cat in categories) {
          for (final m in cat.missions) {
            if (m.id == widget.missionId) {
              mission = m;
              category = cat;
              break;
            }
          }
          if (mission != null) break;
        }
      } catch (e) {
        AppLogger.error('GAMIFICATION: Error loading mission/category: $e');
      }
    }

    // Procesar gamificación si tenemos los datos
    if (mission != null && category != null) {
      AppLogger.log('GAMIFICATION: Processing completion for ${mission.id}');
      final unlockedBadges = await _gamificationService.completeMission(
        mission: mission,
        category: category,
      );

      // Mostrar badges desbloqueados después de un breve delay
      if (unlockedBadges.isNotEmpty && mounted) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          await BadgeUnlockDialog.showMultiple(context, unlockedBadges);
        }
      }
    } else {
      AppLogger.warning(
        'GAMIFICATION: Could not find mission/category for ${widget.missionId}',
      );
    }
  }

  double get scorePercentage {
    if (widget.totalQuestions == 0) return 0.0;
    return (widget.correctAnswers / widget.totalQuestions) * 100;
  }

  bool get isPerfect => widget.correctAnswers == widget.totalQuestions;
  bool get isGood => scorePercentage >= 70;

  @override
  Widget build(BuildContext context) {
    // Color principal basado en resultado
    final accentColor = isPerfect
        ? widget.primaryColor
        : isGood
        ? AppTheme.accentGreen
        : AppTheme.accentBlue;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header con celebración
              _buildCelebrationHeader(accentColor),
              // Contenido con padding
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildScoreCard(accentColor),
                    const SizedBox(height: 20),
                    _buildStatsCards(),
                    const SizedBox(height: 24),
                    _buildLearningSection(),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, accentColor),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header con celebración - animación inmediata
  Widget _buildCelebrationHeader(Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor, accentColor.withValues(alpha: 0.85)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Emoji - animación sutil inmediata
          Text(
                isPerfect
                    ? '🏆'
                    : isGood
                    ? '🎉'
                    : '💪',
                style: const TextStyle(fontSize: 80),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                duration: 800.ms,
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
              ),
          const SizedBox(height: 16),
          // Título - fade inmediato
          Text(
                isPerfect
                    ? '¡PERFECTO!'
                    : isGood
                    ? '¡Excelente Trabajo!'
                    : '¡Buen Intento!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.2, duration: 300.ms),
          const SizedBox(height: 12),
          // Mensaje
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPerfect
                  ? widget.perfectMessage
                  : isGood
                  ? widget.goodMessage
                  : widget.tryAgainMessage,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildScoreCard(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: scorePercentage / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ).animate().scale(
                delay: 150.ms,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
              Column(
                children: [
                  Text(
                    '${scorePercentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  Text(
                    'Puntuación',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, duration: 300.ms);
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            value: widget.correctAnswers.toString(),
            label: 'Correctas',
            color: Colors.green,
            delay: 250,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.cancel,
            value: widget.incorrectAnswers.toString(),
            label: 'Incorrectas',
            color: Colors.red,
            delay: 300,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().slideY(
      delay: delay.ms,
      begin: 0.5,
      duration: 400.ms,
      curve: Curves.easeOut,
    );
  }

  Widget _buildLearningSection() {
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
                      gradient: LinearGradient(
                        colors: [widget.primaryColor, widget.secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('💡', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '¿Qué Aprendiste?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...widget.learningPoints.map(
                (point) => _buildLearningPoint(point),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 350.ms, duration: 300.ms)
        .slideY(begin: 0.1, duration: 300.ms);
  }

  Widget _buildLearningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color accentColor) {
    return Column(
      children: [
        if (widget.showNextButton && widget.onNext != null)
          _buildActionButton(
                context: context,
                label: widget.nextButtonLabel,
                icon: Icons.arrow_forward,
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                ),
                textColor: Colors.white,
                onTap: widget.onNext!,
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 300.ms)
              .slideY(begin: 0.2, duration: 300.ms),
        if (widget.showNextButton && widget.onNext != null)
          const SizedBox(height: 12),
        _buildActionButton(
              context: context,
              label: 'Repetir Actividad',
              icon: Icons.refresh,
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.8)],
              ),
              textColor: Colors.white,
              onTap: () {
                Navigator.of(context).popUntil((route) {
                  return route.isFirst || !Navigator.of(context).canPop();
                });
              },
            )
            .animate()
            .fadeIn(delay: 450.ms, duration: 300.ms)
            .slideY(begin: 0.2, duration: 300.ms),
        const SizedBox(height: 12),
        _buildActionButton(
              context: context,
              label: 'Volver al Inicio',
              icon: Icons.home,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, Color(0xFF3A4F6F)],
              ),
              textColor: Colors.white,
              onTap: () {
                Navigator.of(context).pop('completed');
              },
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 300.ms)
            .slideY(begin: 0.2, duration: 300.ms),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Gradient gradient,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
