import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_question.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_element.dart';

class CiberseguridadQuizData {
  static List<QuizQuestion> _questions = [
    // Question 1: Phishing Email
    QuizQuestion(
      id: 'q1_phishing',
      newsTitle: '¡Urgente! Actualiza tu información bancaria',
      newsContent: 'Hemos detectado actividad sospechosa en tu cuenta. Por favor, haz clic aquí y actualiza tu información inmediatamente para evitar el bloqueo.',
      newsSource: 'BancoFalso.com',
      newsDate: 'Publicado: Hoy',
      newsAuthor: 'Departamento de Seguridad',
      newsShares: 'Compartido: 123 veces',
      newsImage: null,
      elements: [
        const QuizElement(
          id: 'urgency',
          text: '¿El mensaje crea sensación de urgencia?',
          icon: 'alarm',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'sender',
          text: '¿El remitente es desconocido o sospechoso?',
          icon: 'person',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'link',
          text: '¿El enlace parece sospechoso?',
          icon: 'link',
          isCorrect: true,
        ),
      ],
      explanation: '¡Correcto! Este es un intento de phishing. Los correos urgentes, de remitentes desconocidos y con enlaces sospechosos suelen ser fraudulentos.',
    ),

    // Question 2: Malware Download
    QuizQuestion(
      id: 'q2_malware',
      newsTitle: 'Descarga gratis el nuevo juego [Nombre del Juego] ¡Edición Limitada!',
      newsContent: '¡Sé el primero en jugar el nuevo [Nombre del Juego]! Descárgalo ahora desde nuestro sitio web.',
      newsSource: 'SitioWebDeJuegosFalsos.com',
      newsDate: 'Publicado: Ayer',
      newsAuthor: 'Equipo de Desarrollo',
      newsShares: 'Compartido: 456 veces',
      newsImage: null,
      elements: [
        const QuizElement(
          id: 'source',
          text: '¿La fuente es desconocida o no oficial?',
          icon: 'link',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'free',
          text: '¿Ofrecen algo gratis que normalmente cuesta dinero?',
          icon: 'attach_money',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'permissions',
          text: '¿El juego pide permisos extraños al instalarse?',
          icon: 'security',
          isCorrect: true,
        ),
      ],
      explanation: '¡Correcto! Este podría ser un intento de distribuir malware. Descargar software de fuentes no oficiales es peligroso.',
    ),

    // Question 3: Password Strength
    QuizQuestion(
      id: 'q3_passwords',
      newsTitle: '¡Tu contraseña es tu llave!',
      newsContent: '¿Usas la misma contraseña para todo? ¡Es hora de cambiar eso! Una contraseña segura debe ser larga, aleatoria y única.',
      newsSource: 'BlogDeSeguridad.net',
      newsDate: 'Publicado: Hace 1 semana',
      newsAuthor: 'ExpertoEnSeguridad',
      newsShares: 'Compartido: 789 veces',
      newsImage: null,
      elements: [
        const QuizElement(
          id: 'length',
          text: '¿La contraseña tiene menos de 8 caracteres?',
          icon: 'text_fields',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'reuse',
          text: '¿La usas en múltiples sitios web?',
          icon: 'repeat',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'personal',
          text: '¿Contiene información personal fácil de adivinar?',
          icon: 'person',
          isCorrect: true,
        ),
      ],
      explanation: '¡Correcto! Usar contraseñas débiles es un riesgo. Asegúrate de crear contraseñas fuertes y únicas para cada cuenta.',
    ),
  ];

  static List<QuizQuestion> getQuestions() {
    return _questions;
  }

  static QuizQuestion? getQuestionById(String id) {
    return _questions.firstWhere((q) => q.id == id);
  }

  static const String quizTitle = 'Misión Ciberseguridad';
  static const String quizSubtitle = 'Defiende tus Datos';

  static const List<String> instructions = [
    'Lee la situación o noticia presentada',
    'Analiza los elementos de riesgo',
    'Identifica las posibles amenazas',
  ];

  static const String instructionHint = 'Busca pistas en: enlaces, remitentes y permisos';
}
