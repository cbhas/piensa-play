// lib/features/home/presentation/widgets/dashboard_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/mascot_audio_button.dart';

class DashboardHeader extends StatelessWidget {
  final String avatarPath;
  final String? userName;

  const DashboardHeader({super.key, required this.avatarPath, this.userName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentYellow, width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  avatarPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person,
                    size: 35,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                userName != null ? '¡Hola, $userName!' : '¡Hola!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Mascot audio button for menu
            const MascotAudioButton(audioFileName: 'menu.mp3', size: 50),
          ],
        ),
      ),
    );
  }
}
