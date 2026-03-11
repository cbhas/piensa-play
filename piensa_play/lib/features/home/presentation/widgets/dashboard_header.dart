// lib/features/home/presentation/widgets/dashboard_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/mascot_audio_button.dart';
import 'avatar_selector_dialog.dart';

class DashboardHeader extends StatelessWidget {
  final String avatarPath;
  final String? userName;
  final String currentAvatarId;
  final Function(String avatarId, String assetPath)? onAvatarChanged;

  const DashboardHeader({
    super.key,
    required this.avatarPath,
    this.userName,
    this.currentAvatarId = 'cocodrilo',
    this.onAvatarChanged,
  });

  void _openAvatarSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AvatarSelectorDialog(
        currentAvatarId: currentAvatarId,
        onSelect: (avatarId, assetPath) {
          if (onAvatarChanged != null && assetPath != null) {
            onAvatarChanged!(avatarId, assetPath);
          }
        },
      ),
    );
  }

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
            // Avatar - tappable to change
            GestureDetector(
              onTap: () => _openAvatarSelector(context),
              child: Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accentYellow,
                        width: 3,
                      ),
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
                  // Edit indicator
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
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
