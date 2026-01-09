import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/map_header.dart';
import '../widgets/mission_banner.dart';
import '../widgets/mission_node.dart';
import 'veracidadville/quiz_intro_page.dart';
import 'veracidadville/true_false_intro_page.dart';
import 'ciberseguridad/ciberseguridad_intro_page.dart';
import 'zona_cero/word_trail_page.dart';
import 'zona_cero/stereotype_breaker_page.dart';
import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';
import '../../../../core/services/mission_progress_service.dart';

class MissionMapPage extends StatefulWidget {
  final MissionCategory category; // Ahora recibe la categoría completa
  final String? selectedMissionId;
  final String? backgroundImage;
  final Color? bannerColor;

  const MissionMapPage({
    super.key,
    required this.category,
    this.selectedMissionId,
    this.backgroundImage,
    this.bannerColor,
  });

  @override
  State<MissionMapPage> createState() => _MissionMapPageState();
}

class _MissionMapPageState extends State<MissionMapPage> {
  String? selectedMissionId;
  String selectedMissionTitle = 'Selecciona una misión';
  String selectedMissionDescription = 'Toca una misión para comenzar';

  Map<String, bool> missionCompletionStatus = {};
  final _progressService = MissionProgressService();

  // Get missions directly from category
  List<Mission> get _categoryMissions => widget.category.missions;

  // Get node color based on category
  Color get nodeColor {
    if (widget.category.id == 'veracidadville') {
      return const Color(0xFFBDD87B);
    } else if (widget.category.id == 'ciberseguridad') {
      return const Color(0xFF91E0FF);
    } else if (widget.category.id == 'zona_cero_odio') {
      return const Color(0xFFFFEF93);
    }
    return const Color(0xFFBDD87B);
  }

  // Get text color based on category
  Color get textColor {
    if (widget.category.id == 'veracidadville') {
      return const Color(0xFF58CC02);
    } else if (widget.category.id == 'ciberseguridad') {
      return const Color(0xFF132757);
    } else if (widget.category.id == 'zona_cero_odio') {
      return const Color(0xFFFFAE00);
    }
    return const Color(0xFF58CC02);
  }

  @override
  void initState() {
    super.initState();
    selectedMissionId = widget.selectedMissionId;
    _initializeMissionDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgress();
    });
  }

  Future<void> _loadProgress() async {
    final missionIds = _categoryMissions.map((m) => m.id).toList();
    final progress = await _progressService.getCategoryProgress(missionIds);

    if (mounted) {
      setState(() {
        missionCompletionStatus = progress;
      });
    }
  }

  void _initializeMissionDetails() {
    if (widget.selectedMissionId != null) {
      final mission = _categoryMissions.firstWhere(
        (m) => m.id == widget.selectedMissionId,
        orElse: () => _categoryMissions.first,
      );
      selectedMissionTitle = mission.title;
      selectedMissionDescription = mission.description;
    }
  }

  void _selectMission(Mission mission) {
    setState(() {
      if (selectedMissionId == mission.id) {
        _navigateToMission(mission);
        return;
      }

      selectedMissionId = mission.id;
      selectedMissionTitle = mission.title;
      selectedMissionDescription = mission.description;
    });
  }

  void _navigateToMission(Mission mission) {
    // DEBUG: Ver qué tipo de misión llega
    print(
      '🔵 NAVIGATION: Mission ${mission.id}, type: ${mission.type}, category: ${widget.category.id}',
    );

    // Navegación basada en el TIPO de misión, no en IDs hardcodeados
    switch (mission.type) {
      case MissionType.quiz:
        // Para quiz, usamos la página de intro de quiz
        if (widget.category.id == 'veracidadville' &&
            mission.id == 'fake_news') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuizIntroPage()),
          );
        } else if (widget.category.id == 'ciberseguridad') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CiberseguridadIntroPage(currentMission: mission),
            ),
          );
        }
        break;

      case MissionType.trueFalse:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrueFalseIntroPage()),
        );
        break;

      case MissionType.wordSelection:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WordTrailPage()),
        );
        break;

      case MissionType.stereotype:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StereotypeBreakerPage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          MapHeader(
            categoryTitle: widget.category.title,
            audioFileName: widget.category.id == 'veracidadville'
                ? 'veracidadville.mp3'
                : widget.category.id == 'zona_cero_odio'
                ? 'zona_cero_odio.mp3'
                : null,
          ),
          MissionBanner(
            missionTitle: selectedMissionTitle,
            missionDescription: selectedMissionDescription,
            backgroundColor: widget.bannerColor ?? nodeColor,
            textColor: textColor,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: screenWidth,
                height: _calculateMapHeight(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      widget.backgroundImage ??
                          'assets/images/map_background.png',
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Path
                    CustomPaint(
                      size: Size(screenWidth, _calculateMapHeight()),
                      painter: MapPathPainter(
                        points: _getMissionPositions(
                          screenWidth,
                        ).map((m) => m.position).toList(),
                      ),
                    ),
                    // Mission nodes
                    ..._buildMissionNodes(context, screenWidth),
                    // Mascot
                    Positioned(
                      right: 50,
                      top: 350,
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

  // Calcula la altura del mapa dinámicamente basado en el número de misiones
  double _calculateMapHeight() {
    final nodeCount = _categoryMissions.length;
    // 200px base + 200px por cada nodo
    return 200.0 + (nodeCount * 200.0);
  }

  // Genera posiciones de nodos dinámicamente basado en las misiones de la categoría
  List<MapMissionData> _getMissionPositions(double screenWidth) {
    final centerX = screenWidth / 2;
    final missions = <MapMissionData>[];

    for (int i = 0; i < _categoryMissions.length; i++) {
      final mission = _categoryMissions[i];

      // Calcular posición X en zigzag
      final xOffset = (i % 2 == 0) ? 0.0 : (i % 4 == 1 ? -60.0 : 50.0);
      final position = Offset(centerX + xOffset, 200.0 + (i * 200.0));

      // Determinar estado de desbloqueo
      MissionNodeType nodeType;
      if (i == 0) {
        nodeType = MissionNodeType.unlocked;
      } else {
        final previousMission = _categoryMissions[i - 1];
        final isPreviousCompleted =
            missionCompletionStatus[previousMission.id] ?? false;
        nodeType = isPreviousCompleted
            ? MissionNodeType.unlocked
            : MissionNodeType.locked;
      }

      missions.add(
        MapMissionData(
          id: mission.id,
          position: position,
          type: nodeType,
          mission: mission,
        ),
      );
    }

    return missions;
  }

  List<Widget> _buildMissionNodes(BuildContext context, double screenWidth) {
    final missions = _getMissionPositions(screenWidth);

    return missions.asMap().entries.map((entry) {
      final index = entry.key;
      final missionData = entry.value;
      final isSelected = selectedMissionId == missionData.id;

      return Positioned(
        left: missionData.position.dx - 50,
        top: missionData.position.dy - 50,
        child: MissionNodeWidget(
          key: ValueKey(missionData.id),
          type: missionData.type,
          isSelected: isSelected,
          progress: missionData.progress,
          index: index,
          nodeColor: nodeColor,
          onTap: () {
            if (missionData.type != MissionNodeType.locked) {
              _selectMission(missionData.mission);
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
  final Mission mission; // Ahora incluye la misión completa

  MapMissionData({
    required this.id,
    required this.position,
    required this.type,
    this.progress = 0.0,
    required this.mission,
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
