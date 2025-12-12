import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';
import '../datasources/ciberseguridad/ciberseguridad_quiz_data.dart'; // Import CiberseguridadQuizData

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
        colorHex: '0xFF6EC6FF', // accentBlue
        missions: [
          Mission(
            id: 'fake_news',
            title: 'Cazadores de Fake News',
            subtitle: 'Veracidadville', // Added subtitle
            description: 'Aprende a identificar noticias engañosas',
            isCompleted: true,
            iconName: 'check',
            questions: [], // Added questions
          ),
          Mission(
            id: 'titular',
            title: 'El Enigma del Titular',
            subtitle: 'Veracidadville', // Added subtitle
            description: 'Desentraña titulares para encontrar la verdad.',
            isCompleted: false,
            iconName: 'warning',
            questions: [], // Added questions
          ),
        ],
      ),
      MissionCategory(
        id: 'zona_cero_odio',
        title: 'Zona Cero Odio',
        description: 'Reconoce y contrarresta el discurso de odio en línea.',
        iconName: 'message',
        colorHex: '0xFFA4D65E', // accentGreen
        missions: [
          Mission(
            id: 'mensaje_escondido',
            title: 'El Mensaje Escondido',
            subtitle: 'Zona Cero Odio', // Added subtitle
            description: 'Identifica palabras y frases que promueven el odio.',
            isCompleted: false,
            iconName: 'lock',
            questions: [], // Added questions
          ),
        ],
      ),
      MissionCategory(
        id: 'fortaleza_privacidad',
        title: 'Fortaleza Privacidad',
        description: 'Protege tu identidad digital y navega seguro.',
        iconName: 'lock',
        colorHex: '0xFFF4D03F', // accentYellow
        missions: [
          Mission(
            id: 'navegacion_segura',
            title: 'Navegación Segura',
            subtitle: 'Fortaleza Privacidad', // Added subtitle
            description: 'Aprende a proteger tus datos al navegar.',
            isCompleted: false,
            iconName: 'diamond',
            questions: [], // Added questions
          ),
        ],
      ),
      MissionCategory(
        id: 'ciberseguridad', // ID de la categoría actualizado
        title: 'Misión Ciberseguridad', // Título actualizado
        description: 'Defiende el ciberespacio de amenazas y ataques.',
        iconName: 'security',
        colorHex: '0xFFFF6B6B', // accentRed
        missions: [
          Mission(
            id: 'q1_phishing', // ID de la pregunta 1
            title: 'El Ataque Phishing',
            subtitle: 'Ciberseguridad', // Added subtitle
            description: 'Detecta correos y mensajes fraudulentos.',
            isCompleted: false,
            iconName: 'flag',
            questions: [CiberseguridadQuizData.getQuestionById('q1_phishing')!],
          ),
          Mission(
            id: 'q2_malware', // ID de la pregunta 2
            title: 'La Amenaza Oculta',
            subtitle: 'Ciberseguridad', // Added subtitle
            description: 'Identifica software malicioso y protégete.',
            isCompleted: false,
            iconName: 'flag',
            questions: [CiberseguridadQuizData.getQuestionById('q2_malware')!],
          ),
          Mission(
            id: 'q3_passwords', // ID de la pregunta 3
            title: 'Fortaleza de Contraseñas',
            subtitle: 'Ciberseguridad', // Added subtitle
            description: 'Crea contraseñas seguras y robustas.',
            isCompleted: false,
            iconName: 'flag',
            questions: [CiberseguridadQuizData.getQuestionById('q3_passwords')!],
          ),
        ],
      ),
    ];
  }
}
