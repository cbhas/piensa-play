import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';
import '../datasources/ciberseguridad/ciberseguridad_quiz_data.dart';

class MissionsLocalDatasource {
  Future<List<MissionCategory>> getMissionCategories(String userId) async {
    // Simula delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      MissionCategory(
        id: 'veracidadville',
        title: 'Veracidadville',
        description: 'Detecta la desinformación y defiende la verdad.',
        iconName: 'shield',
        colorHex: '0xFF6EC6FF',
        missions: [
          Mission(
            id: 'fake_news',
            title: 'Cazadores de Fake News',
            subtitle: 'Veracidadville',
            description: 'Aprende a identificar noticias engañosas',
            isCompleted: true,
            iconName: 'check',
            type: MissionType.quiz,
            questions: [],
          ),
          Mission(
            id: 'titular',
            title: 'El Enigma del Titular',
            subtitle: 'Veracidadville',
            description: 'Desentraña titulares para encontrar la verdad.',
            isCompleted: false,
            iconName: 'warning',
            type: MissionType.trueFalse,
            questions: [],
          ),
        ],
      ),
      MissionCategory(
        id: 'zona_cero_odio',
        title: 'Zona Cero Odio',
        description: 'Reconoce y contrarresta el discurso de odio en línea.',
        iconName: 'message',
        colorHex: '0xFFA4D65E',
        missions: [
          Mission(
            id: 'words',
            title: 'El Sendero de las Palabras',
            subtitle: 'Zona Cero Odio',
            description: 'Identifica palabras y frases que promueven el odio.',
            isCompleted: false,
            iconName: 'lock',
            type: MissionType.wordSelection,
            questions: [],
          ),
          Mission(
            id: 'stereotypes',
            title: 'Rompe Estereotipos',
            subtitle: 'Zona Cero Odio',
            description: 'Cambia ideas injustas por mensajes amables.',
            isCompleted: false,
            iconName: 'lock',
            type: MissionType.stereotype,
            questions: [],
          ),
        ],
      ),
      MissionCategory(
        id: 'fortaleza_privacidad',
        title: 'Fortaleza Privacidad',
        description: 'Protege tu identidad digital y navega seguro.',
        iconName: 'lock',
        colorHex: '0xFFF4D03F',
        missions: [
          Mission(
            id: 'navegacion_segura',
            title: 'Navegación Segura',
            subtitle: 'Fortaleza Privacidad',
            description: 'Aprende a proteger tus datos al navegar.',
            isCompleted: false,
            iconName: 'diamond',
            type: MissionType.quiz,
            questions: [],
          ),
        ],
      ),
      MissionCategory(
        id: 'ciberseguridad',
        title: 'Misión Ciberseguridad',
        description: 'Defiende el ciberespacio de amenazas y ataques.',
        iconName: 'security',
        colorHex: '0xFFFF6B6B',
        missions: [
          Mission(
            id: 'q1_phishing',
            title: 'El Ataque Phishing',
            subtitle: 'Ciberseguridad',
            description: 'Detecta correos y mensajes fraudulentos.',
            isCompleted: false,
            iconName: 'flag',
            type: MissionType.quiz,
            questions: CiberseguridadQuizData.getQuestions(),
          ),
          Mission(
            id: 'q2_malware',
            title: 'La Amenaza Oculta',
            subtitle: 'Ciberseguridad',
            description: 'Identifica software malicioso y protégete.',
            isCompleted: false,
            iconName: 'flag',
            type: MissionType.quiz,
            questions: CiberseguridadQuizData.getQuestions(),
          ),
          Mission(
            id: 'q3_passwords',
            title: 'Fortaleza de Contraseñas',
            subtitle: 'Ciberseguridad',
            description: 'Crea contraseñas seguras y robustas.',
            isCompleted: false,
            iconName: 'flag',
            type: MissionType.quiz,
            questions: CiberseguridadQuizData.getQuestions(),
          ),
        ],
      ),
    ];
  }
}
