import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/map_header.dart';
import '../widgets/mission_banner.dart';
import '../widgets/mission_node.dart';

class MissionMapPage extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;
  final Color categoryColor;

  const MissionMapPage({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
    required this.categoryColor,
  });

  @override
  State<MissionMapPage> createState() => _MissionMapPageState();
}

class _MissionMapPageState extends State<MissionMapPage> {
  String? selectedMissionId;
  String selectedMissionTitle = 'Selecciona una misión';
  String selectedMissionDescription = 'Toca una misión para comenzar';

  final Map<String, Map<String, String>> missionData = {
    '1': {
      'title': 'El Muro de los Mensajes',
      'description': 'Identifica noticias falsas',
    },
    '2': {
      'title': 'La Fuente de la Verdad',
      'description': 'Aprende a verificar fuentes',
    },
    'chest1': {
      'title': 'Cofre del Tesoro',
      'description': 'Recompensa especial',
    },
  };

  void _selectMission(String missionId) {
    setState(() {
      selectedMissionId = missionId;
      if (missionData.containsKey(missionId)) {
        selectedMissionTitle = missionData[missionId]!['title']!;
        selectedMissionDescription = missionData[missionId]!['description']!;
      }
    });
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
            backgroundColor: const Color(0xFFA4D65E),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: screenWidth,
                height: 1600,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/map_background.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Path
                    CustomPaint(
                      size: Size(screenWidth, 1600),
                      painter: MapPathPainter(
                        points: _getMissionPositions(
                          screenWidth,
                        ).map((m) => m.position).toList(),
                      ),
                    ),
                    // Mission nodes
                    ..._buildMissionNodes(context, screenWidth),
                    // Mascot from assets
                    Positioned(
                      right: 50,
                      top: 650,
                      child:
                          Image.asset(
                                'assets/images/mascot.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.contain,
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .moveY(
                                begin: 0,
                                end: -12,
                                duration: 2200.ms,
                                curve: Curves.easeInOut,
                              )
                              .animate()
                              .fadeIn(delay: 800.ms, duration: 600.ms)
                              .scale(
                                delay: 800.ms,
                                duration: 600.ms,
                                begin: const Offset(0.5, 0.5),
                                curve: Curves.easeOutBack,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MapMissionData> _getMissionPositions(double screenWidth) {
    final centerX = screenWidth / 2;

    return [
      MapMissionData(
        id: '1',
        position: Offset(centerX, 200),
        type: MissionNodeType.unlocked,
      ),
      MapMissionData(
        id: '2',
        position: Offset(centerX - 60, 350),
        type: MissionNodeType.unlocked,
      ),
      MapMissionData(
        id: 'chest1',
        position: Offset(centerX + 50, 500),
        type: MissionNodeType.chest,
      ),
      MapMissionData(
        id: '3',
        position: Offset(centerX - 40, 650),
        type: MissionNodeType.locked,
      ),
      MapMissionData(
        id: '4',
        position: Offset(centerX + 60, 800),
        type: MissionNodeType.locked,
      ),
      MapMissionData(
        id: '5',
        position: Offset(centerX - 50, 950),
        type: MissionNodeType.locked,
      ),
      MapMissionData(
        id: '6',
        position: Offset(centerX + 40, 1100),
        type: MissionNodeType.locked,
      ),
      MapMissionData(
        id: 'chest2',
        position: Offset(centerX - 30, 1250),
        type: MissionNodeType.chest,
      ),
      MapMissionData(
        id: '7',
        position: Offset(centerX + 50, 1400),
        type: MissionNodeType.locked,
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
            if (mission.type != MissionNodeType.locked) {
              _selectMission(mission.id);
            }
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

// Path painter
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
  bool shouldRepaint(MapPathPainter oldDelegate) => false;
}
