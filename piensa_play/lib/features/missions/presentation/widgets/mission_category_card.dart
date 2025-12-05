import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/mission_category.dart';
import 'mission_item.dart';

class MissionCategoryCard extends StatefulWidget {
  final MissionCategory category;

  const MissionCategoryCard({super.key, required this.category});

  @override
  State<MissionCategoryCard> createState() => _MissionCategoryCardState();
}

class _MissionCategoryCardState extends State<MissionCategoryCard> {
  bool _isExpanded = false;

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'shield':
        return Icons.shield;
      case 'message':
        return Icons.message;
      case 'lock':
        return Icons.lock;
      case 'check':
        return Icons.check_circle;
      case 'warning':
        return Icons.error_outline;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.star;
    }
  }

  Color _getColorFromHex(String hex) {
    return Color(int.parse(hex));
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getColorFromHex(widget.category.colorHex);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: categoryColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Category icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconFromName(widget.category.iconName),
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.category.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expand/collapse icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.primaryDark,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          // Missions list (when expanded)
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: widget.category.missions.map((mission) {
                  return MissionItem(
                    title: mission.title,
                    description: mission.description,
                    isCompleted: mission.isCompleted,
                    statusIcon: _getIconFromName(mission.iconName),
                    categoryId: widget.category.id,
                    categoryTitle: widget.category.title,
                    categoryColor: categoryColor,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
