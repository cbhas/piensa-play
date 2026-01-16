import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/mission_category.dart';
import '../pages/mission_map_page.dart';

class MissionCategoryCard extends StatefulWidget {
  final MissionCategory category;

  const MissionCategoryCard({super.key, required this.category});

  @override
  State<MissionCategoryCard> createState() => _MissionCategoryCardState();
}

class _MissionCategoryCardState extends State<MissionCategoryCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

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
      case 'security':
        return Icons.security;
      case 'flag':
        return Icons.flag;
      default:
        return Icons.star;
    }
  }

  Color _getColorFromHex(String hex) {
    String v = hex.trim();

    // Soporta: "#RRGGBB", "#AARRGGBB"
    if (v.startsWith('#')) {
      v = v.substring(1);
      if (v.length == 6) v = 'FF$v'; // alpha por defecto
      v = '0x$v';
    }

    return Color(int.parse(v));
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    });
  }

  void _openMap(BuildContext context) {
    final categoryColor = _getColorFromHex(widget.category.colorHex);

    // Configuración de background y banner por categoría
    String backgroundImage = 'assets/images/map_background.png';
    Color bannerColor = categoryColor;

    if (widget.category.id == 'veracidadville') {
      backgroundImage = 'assets/images/map_background.png';
      bannerColor = const Color(0xFFBDD87B);
    } else if (widget.category.id == 'ciberseguridad') {
      backgroundImage = 'assets/images/map_background_ciberseguridad.png';
      bannerColor = const Color(0xFF91E0FF);
    } else if (widget.category.id == 'zona_cero_odio') {
      backgroundImage = 'assets/images/map_background_zona_cero_odio.png';
      bannerColor = const Color(0xFFFFEF93);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MissionMapPage(
          category: widget.category,
          backgroundImage: backgroundImage,
          bannerColor: bannerColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getColorFromHex(widget.category.colorHex);
    final completedCount = widget.category.missions
        .where((m) => m.isCompleted)
        .length;
    final totalCount = widget.category.missions.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: categoryColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header - siempre visible
          InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Ícono de categoría
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconFromName(widget.category.iconName),
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Título y descripción
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Flecha animada
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _rotationController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.primaryDark,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido expandible con animación
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: [
                      // Divisor
                      Divider(
                        height: 1,
                        color: categoryColor.withValues(alpha: 0.3),
                        indent: 18,
                        endIndent: 18,
                      ),

                      // Lista de misiones (sin botones play individuales)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                        child: Column(
                          children: widget.category.missions
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                                final index = entry.key;
                                final mission = entry.value;
                                return _buildMissionTile(mission, categoryColor)
                                    .animate()
                                    .fadeIn(
                                      delay: Duration(milliseconds: 50 * index),
                                      duration: 200.ms,
                                    )
                                    .slideX(
                                      begin: -0.1,
                                      end: 0,
                                      delay: Duration(milliseconds: 50 * index),
                                      duration: 200.ms,
                                      curve: Curves.easeOut,
                                    );
                              })
                              .toList(),
                        ),
                      ),

                      // Botón JUGAR general
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                        child:
                            SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openMap(context),
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      size: 24,
                                    ),
                                    label: const Text(
                                      'JUGAR',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: categoryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      shadowColor: categoryColor.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 150.ms, duration: 200.ms)
                                .scale(
                                  begin: const Offset(0.95, 0.95),
                                  end: const Offset(1, 1),
                                  delay: 150.ms,
                                  duration: 200.ms,
                                ),
                      ),

                      // Progreso
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppTheme.accentGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$completedCount de $totalCount completadas',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Widget simplificado de misión (sin botón play individual)
  Widget _buildMissionTile(dynamic mission, Color categoryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: mission.isCompleted
              ? AppTheme.accentGreen.withValues(alpha: 0.5)
              : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: mission.isCompleted
                  ? AppTheme.accentGreen.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              mission.isCompleted ? Icons.check : Icons.radio_button_unchecked,
              color: mission.isCompleted
                  ? AppTheme.accentGreen
                  : Colors.grey.shade400,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Mission info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: mission.isCompleted
                        ? Colors.grey.shade600
                        : AppTheme.primaryDark,
                    decoration: mission.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mission.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
