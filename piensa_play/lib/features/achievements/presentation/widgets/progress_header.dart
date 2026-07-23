import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/app_data_service.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userName = AppDataService.instance.userProfile?.name;
    final english = Localizations.localeOf(context).languageCode == 'en';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      child: Row(
        children: [
          // Botón de retroceso
          GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Título
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                english ? 'My Progress' : 'Mi Progreso',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userName != null && userName.isNotEmpty
                    ? (english ? 'Hi, $userName!' : '¡Hola, $userName!')
                    : (english ? 'Hi!' : '¡Hola!'),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
