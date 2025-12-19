import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../pages/mission_map_page.dart';

class MissionItem extends StatelessWidget {
  final String missionId;
  final String title;
  final String description;
  final bool isCompleted;
  final IconData statusIcon;
  final String categoryId;
  final String categoryTitle;
  final Color categoryColor;

  const MissionItem({
    super.key,
    required this.missionId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.statusIcon,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryColor,
  });

  void _openMission(BuildContext context) {
    debugPrint('MISSION ID: $missionId | CATEGORY ID: $categoryId');

    // =========================
    // 1) RUTEO POR CATEGORÍA (principal)
    // =========================

    // Veracidadville -> MissionMapPage
    if (categoryId == 'veracidadville') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MissionMapPage(
            categoryTitle: categoryTitle,
            categoryId: categoryId,
            categoryColor: categoryColor,
            backgroundImage: 'assets/images/map_background.png',
            bannerColor: const Color(0xFFBDD87B), // Verde claro
          ),
        ),
      );
      return;
    }

    // Ciberseguridad -> MissionMapPage
    if (categoryId == 'ciberseguridad') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MissionMapPage(
            categoryTitle: categoryTitle,
            categoryId: categoryId,
            categoryColor: categoryColor,
            selectedMissionId: missionId,
            backgroundImage: 'assets/images/map_background_ciberseguridad.png',
            bannerColor: const Color(0xFF91E0FF), // Azul claro
          ),
        ),
      );
      return;
    }

    // Zona Cero Odio -> MissionMapPage (ahora también usa el mapa unificado)
    if (categoryId == 'zona_cero_odio') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MissionMapPage(
            categoryTitle: categoryTitle,
            categoryId: categoryId,
            categoryColor: categoryColor,
            backgroundImage: 'assets/images/map_background_zona_cero_odio.png',
            bannerColor: const Color(0xFFFFEF93), // Amarillo claro
          ),
        ),
      );
      return;
    }

    // =========================
    // 2) RUTEO POR MISIÓN (backup)
    // =========================
    // Si un día cambias categoryId, igual abre lo correcto.
    if (missionId == 'q1_phishing' ||
        missionId == 'q2_malware' ||
        missionId == 'q3_passwords') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MissionMapPage(
            categoryTitle: categoryTitle,
            categoryId: 'ciberseguridad',
            categoryColor: categoryColor,
            selectedMissionId: missionId,
          ),
        ),
      );
      return;
    }

    // =========================
    // 3) FALLBACK
    // =========================
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Próximamente...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.accentGreen.withOpacity(0.2)
                  : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: isCompleted ? AppTheme.accentGreen : Colors.red.shade400,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Play button
          GestureDetector(
            onTap: () => _openMission(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.accentGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGreen.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
