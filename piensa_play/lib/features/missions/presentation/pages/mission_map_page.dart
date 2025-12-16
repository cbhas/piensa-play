import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/map_header.dart';
import '../widgets/mission_banner.dart';
import '../widgets/mission_node.dart';
import 'veracidadville/quiz_intro_page.dart';
import 'veracidadville/true_false_intro_page.dart';
import 'ciberseguridad/ciberseguridad_intro_page.dart'; // Importar la nueva página de introducción
import '../../domain/entities/mission.dart'; // Import Mission entity
import '../../domain/entities/veracidadville/quiz_question.dart';

class MissionMapPage extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;
  final Color categoryColor;
  final String? selectedMissionId; // Añadir el parámetro selectedMissionId

  const MissionMapPage({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
    required this.categoryColor,
    this.selectedMissionId, // Hacerlo opcional o requerido según la lógica
  });

  @override
  State<MissionMapPage> createState() => _MissionMapPageState();
}

class _MissionMapPageState extends State<MissionMapPage> {
  String? selectedMissionId;
  String selectedMissionTitle = 'Selecciona una misión';
  String selectedMissionDescription = 'Toca una misión para comenzar';

  @override
  void initState() {
    super.initState();
    selectedMissionId = widget.selectedMissionId;
    // Aquí podrías inicializar selectedMissionTitle y selectedMissionDescription
    // basándote en widget.selectedMissionId si es necesario.
    // Por ahora, lo dejaremos como está para no complicar la lógica de los nodos del mapa.
    _initializeMissionDetails();
  }

  void _initializeMissionDetails() {
    if (widget.selectedMissionId != null && missionData.containsKey(widget.selectedMissionId!)) {
      selectedMissionTitle = missionData[widget.selectedMissionId!]!['title']!;
      selectedMissionDescription = missionData[widget.selectedMissionId!]!['description']!;
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
  };

  void _selectMission(String missionId) {
    setState(() {
      selectedMissionId = missionId;
      if (missionData.containsKey(missionId)) {
        selectedMissionTitle = missionData[missionId]!['title']!;
        selectedMissionDescription = missionData[missionId]!['description']!;
      }
    });

    if (widget.categoryId == 'veracidadville') {
      if (missionId == 'fake_news') { // Usar IDs de misión reales
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizIntroPage()),
        );
      } else if (missionId == 'titular') { // Usar IDs de misión reales
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrueFalseIntroPage()),
        );
      }
    } else if (widget.categoryId == 'ciberseguridad') { // Usar el ID de categoría actualizado
      // Aquí puedes decidir si cada misión de ciberseguridad tiene su propia intro
      // o si todas van a la misma intro general de ciberseguridad.
      // Por ahora, asumiremos que todas las misiones de ciberseguridad van a la misma intro.
      final mission = Mission(
        id: missionId,
        title: selectedMissionTitle,
        subtitle: 'Ciberseguridad',
        description: selectedMissionDescription,
        isCompleted: false,
        iconName: 'shield',
        questions: [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CiberseguridadIntroPage(
            currentMission: mission,
          ),
        ),
      );
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
            backgroundColor: widget.categoryColor, // Usar el color de la categoría
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: screenWidth,
                height: 800, // Reduced height for 3 nodes
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

    // Las posiciones de las misiones deberían ser dinámicas o configurables
    // para cada categoría. Por ahora, mantendremos 3 nodos de ejemplo.
    // Si necesitas más nodos o posiciones específicas para Operación Ciberseguridad,
    // deberíamos crear una lógica para ello.
    if (widget.categoryId == 'ciberseguridad') {
      return [
        MapMissionData(
          id: 'q1_phishing', // Usar IDs de misión reales
          position: Offset(centerX, 200),
          type: MissionNodeType.unlocked,
        ),
        MapMissionData(
          id: 'q2_malware', // Usar IDs de misión reales
          position: Offset(centerX - 60, 400),
          type: MissionNodeType.unlocked,
        ),
        MapMissionData(
          id: 'q3_passwords', // Usar IDs de misión reales
          position: Offset(centerX + 50, 600),
          type: MissionNodeType.locked, // Puedes cambiar esto a unlocked si quieres que todas estén disponibles
        ),
      ];
    } else if (widget.categoryId == 'veracidadville') {
      return [
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
          id: '3', // Este ID no corresponde a una misión real en veracidadville_quiz_data.dart
          position: Offset(centerX + 50, 600),
          type: MissionNodeType.locked,
        ),
      ];
    }
    return []; // Retornar una lista vacía por defecto
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
