// lib/features/home/presentation/widgets/mission_banner.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Banner dinámico para la pregunta del día
/// Muestra diferentes estados: disponible, completado, streak
class MissionBanner extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isAvailable;
  final bool isCompleted;
  final Duration? timeRemaining;
  final int streak;

  const MissionBanner({
    super.key,
    required this.onPressed,
    this.isAvailable = true,
    this.isCompleted = false,
    this.timeRemaining,
    this.streak = 0,
  });

  @override
  State<MissionBanner> createState() => _MissionBannerState();
}

class _MissionBannerState extends State<MissionBanner> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.isCompleted && widget.timeRemaining != null) {
      _remaining = widget.timeRemaining!;
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(MissionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted && widget.timeRemaining != null) {
      _remaining = widget.timeRemaining!;
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    // Determinar colores y contenido según estado
    Color backgroundColor;
    String title;
    String subtitle;
    String buttonText;
    IconData? streakIcon;

    if (widget.isCompleted) {
      // Estado: Completado
      backgroundColor = AppTheme.accentGreen;
      title = '¡Bien hecho!';
      subtitle = 'Vuelve en ${_formatDuration(_remaining)}';
      buttonText = 'Ver logros';
    } else if (widget.streak >= 3) {
      // Estado: Streak activo
      backgroundColor = Colors.orange;
      title = '🔥 ${widget.streak} días seguidos';
      subtitle = '¡Mantén la racha!';
      buttonText = 'Jugar';
      streakIcon = Icons.local_fire_department;
    } else {
      // Estado: Disponible
      backgroundColor = AppTheme.accentYellow;
      title = '¡Pregunta del día!';
      subtitle = 'Gana XP y monedas';
      buttonText = 'Jugar';
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.defaultShadow,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Contenido principal - TODO CENTRADO
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (streakIcon != null) ...[
                    Icon(streakIcon, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.isCompleted || widget.streak >= 3
                          ? Colors.white
                          : AppTheme.tertiaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isCompleted || widget.streak >= 3
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppTheme.tertiaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isCompleted || widget.streak >= 3
                        ? Colors.white
                        : AppTheme.tertiaryDark,
                    foregroundColor: widget.isCompleted
                        ? AppTheme.accentGreen
                        : (widget.streak >= 3 ? Colors.orange : Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Mascota flotante en BOTTOM-RIGHT (esquina inferior derecha)
          Positioned(
            right: -65,
            bottom: -15,
            child: Container(
              width: 140,
              height: 145,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 50,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/mascot.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.pets, size: 100, color: Colors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
