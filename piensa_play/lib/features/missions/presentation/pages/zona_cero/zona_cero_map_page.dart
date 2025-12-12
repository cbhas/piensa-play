import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../widgets/map_header.dart';
import '../../widgets/mission_banner.dart';
import '../../widgets/mission_node.dart';
import 'word_trail_page.dart';
import 'stereotype_breaker_page.dart';

class ZonaCeroMapPage extends StatefulWidget {
  final String categoryTitle;
  final Color categoryColor;

  const ZonaCeroMapPage({
    super.key,
    required this.categoryTitle,
    required this.categoryColor,
  });

  @override
  State<ZonaCeroMapPage> createState() => _ZonaCeroMapPageState();
}

class _ZonaCeroMapPageState extends State<ZonaCeroMapPage> {
  String? selectedMissionId;
  String selectedMissionTitle = 'Elige una aventura';
  String selectedMissionDescription = 'Toca un punto del mapa para comenzar';

  bool wordTrailCompleted = false;
  bool stereotypeCompleted = false;

  final Map<String, Map<String, String>> missionData = {
    'words': {
      'title': 'El sendero de las palabras',
      'description': 'Elige si las frases hieren o ayudan',
    },
    'stereotypes': {
      'title': 'Rompe estereotipos',
      'description': 'Cambia ideas injustas por mensajes amables',
    },
  };

  Future<void> _selectMission(String missionId) async {
    final missions = _getMissionPositions(MediaQuery.of(context).size.width);
    final selected = missions.firstWhere((element) => element.id == missionId);
    if (selected.type == MissionNodeType.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa la misión anterior para desbloquear.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      selectedMissionId = missionId;
      selectedMissionTitle = missionData[missionId]!['title']!;
      selectedMissionDescription = missionData[missionId]!['description']!;
    });

    if (missionId == 'words') {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const WordTrailPage()),
      );
      if (!mounted) return;
      if (result == 'repeat') return;
      if (result == 'completed' || result == 'next') {
        setState(() {
          wordTrailCompleted = true;
        });
        if (result == 'next') {
          await Future.delayed(const Duration(milliseconds: 150));
          _selectMission('stereotypes');
        }
      }
    } else if (missionId == 'stereotypes') {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const StereotypeBreakerPage()),
      );
      if (!mounted) return;
      if (result == 'repeat') return;
      if (result != null) {
        setState(() {
          stereotypeCompleted = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          MapHeader(categoryTitle: widget.categoryTitle),
          MissionBanner(
            missionTitle: selectedMissionTitle,
            missionDescription: selectedMissionDescription,
            backgroundColor: widget.categoryColor,
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/map_background.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.1),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: screenWidth,
                    height: 820,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: Size(screenWidth, 820),
                          painter: MapPathPainter(
                            points: _getMissionPositions(
                              screenWidth,
                            ).map((m) => m.position).toList(),
                          ),
                        ),
                        ..._buildMissionNodes(context, screenWidth),
                        Positioned(
                          left: 26,
                          top: 520,
                          child: _buildMascot(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascot() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.menu_book, color: AppTheme.primaryDark, size: 18),
              SizedBox(width: 8),
              Text(
                'Bosque de los Ecos Digitales',
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Image.asset(
          'assets/images/mascot.png',
          width: 130,
          height: 130,
          fit: BoxFit.contain,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(begin: 0, end: -10, duration: 2000.ms, curve: Curves.easeInOut)
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.easeOutBack,
            ),
      ],
    );
  }

  List<MapMissionData> _getMissionPositions(double screenWidth) {
    final centerX = screenWidth / 2;

    return [
      MapMissionData(
        id: 'words',
        position: Offset(centerX - 30, 220),
        type: wordTrailCompleted
            ? MissionNodeType.completed
            : MissionNodeType.unlocked,
        progress: wordTrailCompleted ? 1.0 : 0.2,
      ),
      MapMissionData(
        id: 'stereotypes',
        position: Offset(centerX + 40, 420),
        type: wordTrailCompleted
            ? (stereotypeCompleted
                ? MissionNodeType.completed
                : MissionNodeType.unlocked)
            : MissionNodeType.locked,
        progress: stereotypeCompleted ? 1.0 : 0.0,
      ),
      MapMissionData(
        id: 'chest',
        position: Offset(centerX - 10, 640),
        type: wordTrailCompleted && stereotypeCompleted
            ? MissionNodeType.chest
            : MissionNodeType.locked,
      ),
    ];
  }

  List<Widget> _buildMissionNodes(BuildContext context, double screenWidth) {
    final missions = _getMissionPositions(screenWidth);

    return missions.asMap().entries.map((entry) {
      final index = entry.key;
      final mission = entry.value;
      final isSelected = selectedMissionId == mission.id;

      return Positioned(
        left: mission.position.dx - 50,
        top: mission.position.dy - 50,
        child: MissionNodeWidget(
          key: ValueKey(mission.id),
          type: mission.type,
          isSelected: isSelected,
          progress: mission.progress,
          index: index,
          onTap: () {
            if (mission.type == MissionNodeType.chest) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Sorpresa guardada para más tarde!'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            if (!missionData.containsKey(mission.id)) return;
            _selectMission(mission.id);
          },
        ),
      );
    }).toList();
  }
}

class MapMissionData {
  final String id;
  final Offset position;
  final MissionNodeType type;
  final double progress;

  MapMissionData({
    required this.id,
    required this.position,
    required this.type,
    this.progress = 0.0,
  });
}

class MapPathPainter extends CustomPainter {
  final List<Offset> points;

  MapPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      final controlPoint1 = Offset(
        current.dx + (next.dx - current.dx) / 3,
        current.dy + (next.dy - current.dy) / 2,
      );
      final controlPoint2 = Offset(
        current.dx + 2 * (next.dx - current.dx) / 3,
        current.dy + (next.dy - current.dy) / 2,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(path, shadowPaint);

    final outlinePaint = Paint()
      ..color = const Color(0xFFB8A888)
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, outlinePaint);

    final pathPaint = Paint()
      ..color = const Color(0xFFD4C5A0)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, pathPaint);

    final highlightPaint = Paint()
      ..color = const Color(0xFFE8DCC8).withOpacity(0.5)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant MapPathPainter oldDelegate) => false;
}
