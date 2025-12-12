import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../pages/mission_map_page.dart';
import '../pages/zona_cero/zona_cero_map_page.dart';

class MissionItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final IconData statusIcon;
  final String categoryId;
  final String categoryTitle;
  final Color categoryColor;

  const MissionItem({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.statusIcon,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryColor,
  });

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
            onTap: () {
              // Navigate to mission map for the selected category
              if (categoryId == 'veracidadville') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MissionMapPage(
                      categoryTitle: categoryTitle,
                      categoryId: categoryId,
                      categoryColor: categoryColor,
                    ),
                  ),
                );
              } else if (categoryId == 'zona_cero_odio') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZonaCeroMapPage(
                      categoryTitle: categoryTitle,
                      categoryColor: categoryColor,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Próximamente...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
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
