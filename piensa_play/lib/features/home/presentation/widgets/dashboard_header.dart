// lib/features/home/presentation/widgets/dashboard_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String avatarPath;

  const DashboardHeader({
    super.key,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.tertiaryDark, // CAMBIADO: Más oscuro
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
            const SizedBox(width: 16),
            const Text(
              '¡Hola!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
