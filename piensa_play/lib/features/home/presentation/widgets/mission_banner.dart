// lib/features/home/presentation/widgets/mission_banner.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MissionBanner extends StatelessWidget {
  final VoidCallback onPressed;

  const MissionBanner({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.accentYellow,
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
              const Text(
                '¡Nueva misión!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '¡Aprende algo nuevo cada día!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.tertiaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.tertiaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Empezar',
                    style: TextStyle(
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
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 50,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/mascot.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.pets,
                  size: 100,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
