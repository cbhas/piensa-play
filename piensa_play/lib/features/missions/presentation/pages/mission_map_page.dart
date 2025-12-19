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
import '../../data/datasources/missions_local_datasource.dart';
import '../../../../core/services/mission_progress_service.dart';

class MissionMapPage extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;
  final Color categoryColor;
  final String? selectedMissionId;
  final String? backgroundImage; // Configurable background
  final Color? bannerColor; // Configurable banner color

  const MissionMapPage({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
    required this.categoryColor,
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

  // Sequential unlock system
  Map<String, bool> missionCompletionStatus = {};
  final _progressService = MissionProgressService();
  final _datasource = MissionsLocalDatasource();
  List<Mission> _categoryMissions = [];

  // Get node color based on category
  Color get nodeColor {
    if (widget.categoryId == 'veracidadville') {
      return const Color(0xFFBDD87B); // Verde claro
    } else if (widget.categoryId == 'ciberseguridad') {
      return const Color(0xFF91E0FF); // Azul claro
    } else if (widget.categoryId == 'zona_cero_odio') {
      return const Color(0xFFFFEF93); // Amarillo claro
    }
    return const Color(0xFFBDD87B); // Default verde
  }

  // Get text color based on category (for banner text and PLAY button)
  Color get textColor {
    if (widget.categoryId == 'veracidadville') {
      return const Color(0xFF58CC02); // Verde oscuro
    } else if (widget.categoryId == 'ciberseguridad') {
      return const Color(0xFF132757); // Azul oscuro
    } else if (widget.categoryId == 'zona_cero_odio') {
      return const Color(0xFFFFAE00); // Amarillo oscuro
    }
    return const Color(0xFF58CC02); // Default verde oscuro
  }

  @override
  void initState() {
    super.initState();
    selectedMissionId = widget.selectedMissionId;
    _initializeMissionDetails();
    // Defer loading progress until after first frame to avoid MediaQuery error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgress();
      _loadMissions(); // Load missions from data source
    });
  }

  Future<void> _loadProgress() async {
    // Get all mission IDs for this category
    final missions = _getMissionPositions(MediaQuery.of(context).size.width);
    final missionIds = missions.map((m) => m.id).toList();

    // Load progress from storage
    final progress = await _progressService.getCategoryProgress(missionIds);

    if (mounted) {
      setState(() {
        missionCompletionStatus = progress;
      });
    }
  }

  Future<void> _loadMissions() async {
    try {
      final categories = await _datasource.getMissionCategories('user_id');
      final category = categories.firstWhere(
        (cat) => cat.id == widget.categoryId,
        orElse: () => categories.first,
      );
      if (mounted) {
        setState(() {
          _categoryMissions = category.missions;
        });
      }
    } catch (e) {
      print('Error loading missions: $e');
    }
  }

  void _initializeMissionDetails() {
    if (widget.selectedMissionId != null &&
        missionData.containsKey(widget.selectedMissionId!)) {
      selectedMissionTitle = missionData[widget.selectedMissionId!]!['title']!;
      selectedMissionDescription =
          missionData[widget.selectedMissionId!]!['description']!;
    }
  }

  final Map<String, Map<String, String>> missionData = {
    'fake_news': {
      'title': 'Cazadores de Fake News',
      'description': 'Aprende a identificar noticias engañosas',
    },
    'titular': {
      'title': 'El Enigma del Titular',
      'description': 'Desentraña titulares para encontrar la verdad.',
    },
    'q1_phishing': {
      'title': 'El Ataque Phishing',
      'description': 'Detecta correos y mensajes fraudulentos.',
    },
    'q2_malware': {
      'title': 'La Amenaza Oculta',
      'description': 'Identifica software malicioso y protégete.',
    },
    'q3_passwords': {
      'title': 'Fortaleza de Contraseñas',
      'description': 'Crea contraseñas seguras y robustas.',
    },
    // Zona Cero Odio missions
    'words': {
      'title': 'El sendero de las palabras',
      'description': 'Elige si las frases hieren o ayudan',
    },
    'stereotypes': {
      'title': 'Rompe estereotipos',
      'description': 'Cambia ideas injustas por mensajes amables',
    },
  };

  void _selectMission(String missionId) {
    setState(() {
      // If already selected, navigate to mission
      if (selectedMissionId == missionId) {
        _navigateToMission(missionId);
        return;
      }

      // First click: just update selection and banner
      selectedMissionId = missionId;
      if (missionData.containsKey(missionId)) {
        selectedMissionTitle = missionData[missionId]!['title']!;
        selectedMissionDescription = missionData[missionId]!['description']!;
      }
    });
  }

  void _navigateToMission(String missionId) {
    if (widget.categoryId == 'veracidadville') {
      if (missionId == 'fake_news') {
        // Usar IDs de misión reales
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizIntroPage()),
        );
      } else if (missionId == 'titular') {
        // Usar IDs de misión reales
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrueFalseIntroPage()),
        );
      }
    } else if (widget.categoryId == 'ciberseguridad') {
      // Get actual mission from loaded data
      final mission = _categoryMissions.firstWhere(
        (m) => m.id == missionId,
        orElse: () => Mission(
          id: missionId,
          title: selectedMissionTitle,
          subtitle: 'Ciberseguridad',
          description: selectedMissionDescription,
          isCompleted: false,
          iconName: 'shield',
          questions: [],
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CiberseguridadIntroPage(currentMission: mission),
        ),
      );
    } else if (widget.categoryId == 'zona_cero_odio') {
      if (missionId == 'words') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WordTrailPage()),
        );
      } else if (missionId == 'stereotypes') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StereotypeBreakerPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          MapHeader(
            categoryTitle: widget.categoryTitle,
            audioFileName: widget.categoryId == 'veracidadville'
                ? 'veracidadville.mp3'
                : widget.categoryId == 'zona_cero_odio'
                ? 'zona_cero_odio.mp3'
                : null,
          ),
          MissionBanner(
            missionTitle: selectedMissionTitle,
            missionDescription: selectedMissionDescription,
            backgroundColor: widget.bannerColor ?? nodeColor,
            textColor: textColor, // Use category-specific text color
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: screenWidth,
                height: 800, // Reduced height for 3 nodes
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
                      size: Size(screenWidth, 800),
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

  List<MapMissionData> _getMissionPositions(double screenWidth) {
    final centerX = screenWidth / 2;

    // Define base missions for each category
    List<MapMissionData> baseMissions = [];

    if (widget.categoryId == 'ciberseguridad') {
      baseMissions = [
        MapMissionData(
          id: 'q1_phishing',
          position: Offset(centerX, 200),
          type: MissionNodeType.unlocked, // Will be updated by unlock logic
        ),
        MapMissionData(
          id: 'q2_malware',
          position: Offset(centerX - 60, 400),
          type: MissionNodeType.unlocked,
        ),
        MapMissionData(
          id: 'q3_passwords',
          position: Offset(centerX + 50, 600),
          type: MissionNodeType.locked,
        ),
      ];
    } else if (widget.categoryId == 'veracidadville') {
      baseMissions = [
        MapMissionData(
          id: 'fake_news',
          position: Offset(centerX, 200),
          type: MissionNodeType.unlocked,
        ),
        MapMissionData(
          id: 'titular',
          position: Offset(centerX - 60, 400),
          type: MissionNodeType.unlocked,
        ),
        MapMissionData(
          id: '3',
          position: Offset(centerX + 50, 600),
          type: MissionNodeType.locked,
        ),
      ];
    } else if (widget.categoryId == 'zona_cero_odio') {
      baseMissions = [
        MapMissionData(
          id: 'words',
          position: Offset(centerX, 200),
          type: MissionNodeType.unlocked,
        ),
        MapMissionData(
          id: 'stereotypes',
          position: Offset(centerX - 60, 400),
          type: MissionNodeType.unlocked,
        ),
      ];
    }

    // Apply sequential unlock logic
    final unlockedMissions = <MapMissionData>[];
    for (int i = 0; i < baseMissions.length; i++) {
      final mission = baseMissions[i];

      if (i == 0) {
        // First mission is always unlocked
        unlockedMissions.add(
          MapMissionData(
            id: mission.id,
            position: mission.position,
            type: MissionNodeType.unlocked,
          ),
        );
      } else {
        // Check if previous mission is completed
        final previousMission = baseMissions[i - 1];
        final isPreviousCompleted =
            missionCompletionStatus[previousMission.id] ?? false;

        unlockedMissions.add(
          MapMissionData(
            id: mission.id,
            position: mission.position,
            type: isPreviousCompleted
                ? MissionNodeType.unlocked
                : MissionNodeType.locked,
          ),
        );
      }
    }

    return unlockedMissions;
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
          nodeColor: nodeColor, // Pass category-specific color
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
