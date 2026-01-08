import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';
import '../pages/mission_map_page.dart';

class MissionItem extends StatelessWidget {
  final Mission mission;
  final MissionCategory category;

  const MissionItem({super.key, required this.mission, required this.category});

  Color _getColorFromHex(String hex) {
    String v = hex.trim();
    if (v.startsWith('#')) {
      v = v.substring(1);
      if (v.length == 6) v = 'FF$v';
      v = '0x$v';
    }
    return Color(int.parse(v));
  }

  void _openMission(BuildContext context) {
    final categoryColor = _getColorFromHex(category.colorHex);

    debugPrint(
      'MISSION ID: ${mission.id} | CATEGORY ID: ${category.id} | TYPE: ${mission.type}',
    );

    // Configuración de background y banner por categoría
    String backgroundImage = 'assets/images/map_background.png';
    Color bannerColor = categoryColor;

    if (category.id == 'veracidadville') {
      backgroundImage = 'assets/images/map_background.png';
      bannerColor = const Color(0xFFBDD87B);
    } else if (category.id == 'ciberseguridad') {
      backgroundImage = 'assets/images/map_background_ciberseguridad.png';
      bannerColor = const Color(0xFF91E0FF);
    } else if (category.id == 'zona_cero_odio') {
      backgroundImage = 'assets/images/map_background_zona_cero_odio.png';
      bannerColor = const Color(0xFFFFEF93);
    }

    // Navegación dinámica - pasa la categoría completa
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MissionMapPage(
          category: category, // Ahora pasamos la categoría completa
          selectedMissionId: mission.id,
          backgroundImage: backgroundImage,
          bannerColor: bannerColor,
        ),
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
              color: mission.isCompleted
                  ? AppTheme.accentGreen.withOpacity(0.2)
                  : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              mission.isCompleted ? Icons.check_circle : Icons.flag,
              color: mission.isCompleted
                  ? AppTheme.accentGreen
                  : Colors.red.shade400,
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
                  mission.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mission.description,
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
