import '../../domain/entities/mission.dart';
import '../../domain/entities/mission_category.dart';

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
            description: 'Aprende a identificar noticias engañosas',
            isCompleted: true,
            iconName: 'check',
          ),
          Mission(
            id: 'titular',
            title: 'El Enigma del Titular',
            description: 'Desentraña titulares para encontrar la verdad.',
            isCompleted: false,
            iconName: 'warning',
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
            description: 'Identifica palabras y frases que promueven el odio.',
            isCompleted: false,
            iconName: 'lock',
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
            description: 'Aprende a proteger tus datos al navegar.',
            isCompleted: false,
            iconName: 'diamond',
          ),
        ],
      ),
    ];
  }
}
