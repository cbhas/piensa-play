import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';

class MissionsLocalDatasource {
  Future<List<MissionCategory>> getMissionCategories(String userId) async {
    // Simula delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      // =========================================================================
      // VERACIDADVILLE - 3 Misiones
      // =========================================================================
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
            isCompleted: false,
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
          Mission(
            id: 'fuentes_confiables',
            title: 'Fuentes Confiables',
            subtitle: 'Veracidadville',
            description:
                'Aprende a identificar fuentes de información confiables.',
            isCompleted: false,
            iconName: 'search',
            type: MissionType.quiz,
            questions: [],
          ),
        ],
      ),
      // =========================================================================
      // ZONA CERO ODIO - 3 Misiones
      // =========================================================================
      MissionCategory(
        id: 'zona_cero_odio',
        title: 'Zona Cero Odio',
        description: 'Reconoce y contrarresta el discurso de odio en línea.',
        iconName: 'message',
        colorHex: '0xFFA4D65E',
        missions: [
          Mission(
            id: 'mensaje_escondido',
            title: 'El Mensaje Escondido',
            subtitle: 'Zona Cero Odio',
            description: 'Identifica palabras y frases que promueven el odio.',
            isCompleted: false,
            iconName: 'lock',
            type: MissionType.wordSelection,
            questions: [],
          ),
          Mission(
            id: 'empatia_digital',
            title: 'Empatía Digital',
            subtitle: 'Zona Cero Odio',
            description: 'Aprende a responder con empatía en línea.',
            isCompleted: false,
            iconName: 'favorite',
            type: MissionType.quiz,
            questions: [],
          ),
          Mission(
            id: 'reportar_odio',
            title: 'Reportar y Actuar',
            subtitle: 'Zona Cero Odio',
            description: 'Aprende cuándo y cómo reportar contenido de odio.',
            isCompleted: false,
            iconName: 'flag',
            type: MissionType.trueFalse,
            questions: [],
          ),
        ],
      ),
      // =========================================================================
      // CIBERSEGURIDAD - 3 Misiones
      // =========================================================================
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
            questions: [],
          ),
          Mission(
            id: 'q2_malware',
            title: 'La Amenaza Oculta',
            subtitle: 'Ciberseguridad',
            description: 'Identifica software malicioso y protégete.',
            isCompleted: false,
            iconName: 'flag',
            type: MissionType.quiz,
            questions: [],
          ),
          Mission(
            id: 'q3_passwords',
            title: 'Fortaleza de Contraseñas',
            subtitle: 'Ciberseguridad',
            description: 'Crea contraseñas seguras y robustas.',
            isCompleted: false,
            iconName: 'flag',
            type: MissionType.quiz,
            questions: [],
          ),
        ],
      ),
    ];
  }
}
