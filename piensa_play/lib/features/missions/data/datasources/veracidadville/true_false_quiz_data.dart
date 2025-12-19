import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../../domain/entities/veracidadville/quiz_element.dart';
import '../../../domain/entities/veracidadville/question_type.dart';

class TrueFalseQuizData {
  static const String quizTitle = 'Veracidadville';
  static const String quizSubtitle = 'Detecta Fake News';

  static List<QuizQuestion> getQuestions() {
    return [
      // Pregunta 1: Cura mágica para el resfriado (FALSO)
      QuizQuestion(
        id: 'tf_q1',
        newsSource: 'SaludTotal.com',
        newsAuthor: '@SuperSaludable',
        newsDate: 'Hace 2 horas',
        newsTitle: '¡CURA MÁGICA PARA EL RESFRIADO!',
        newsContent:
            'Científicos descubren que beber agua con limón y miel ¡ELIMINA INSTANTÁNEAMENTE CUALQUIER VIRUS! Compartir con todos tus contactos para protegerlos. 🍋',
        newsShares: '15.2K compartidos',
        elements: [
          const QuizElement(
            id: 'true',
            text: 'Verdadero',
            icon: 'check_circle',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'false',
            text: 'Falso',
            icon: 'cancel',
            isCorrect: true,
          ),
        ],
        explanation:
            '¡Correcto! Esta noticia es FALSA. El lenguaje exagerado, la falta de fuentes verificables y la presión para compartir son señales claras de desinformación.',
        type: QuestionType.trueFalse,
        correctAnswer: false,
        clues: [
          'Lenguaje exagerado: "ELIMINA INSTANTÁNEAMENTE"',
          'Amenaza o presión: "Compartir o podrías enfermar"',
          'Falta de fuentes científicas verificables',
          'Uso de mayúsculas y signos de exclamación excesivos',
        ],
      ),

      // Pregunta 2: Descubrimiento científico real (VERDADERO)
      QuizQuestion(
        id: 'tf_q2',
        newsSource: 'CienciaHoy.edu',
        newsAuthor: 'Dr. María González',
        newsDate: 'Hace 1 día',
        newsTitle: 'Estudio revela beneficios del ejercicio regular',
        newsContent:
            'Investigadores de la Universidad Nacional publicaron un estudio en la revista médica "The Lancet" que muestra cómo 30 minutos de ejercicio diario pueden mejorar la salud cardiovascular. El estudio incluyó 5,000 participantes durante 2 años.',
        newsShares: '2.3K compartidos',
        elements: [
          const QuizElement(
            id: 'true',
            text: 'Verdadero',
            icon: 'check_circle',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'false',
            text: 'Falso',
            icon: 'cancel',
            isCorrect: false,
          ),
        ],
        explanation:
            '¡Correcto! Esta noticia es VERDADERA. Tiene fuentes verificables, datos específicos y lenguaje profesional. Es información confiable.',
        type: QuestionType.trueFalse,
        correctAnswer: true,
        clues: [
          'Fuente verificable: Universidad Nacional',
          'Publicación en revista científica reconocida',
          'Datos específicos: 5,000 participantes, 2 años',
          'Lenguaje moderado y profesional',
        ],
      ),

      // Pregunta 3: Teoría de conspiración (FALSO)
      QuizQuestion(
        id: 'tf_q3',
        newsSource: 'NoticiasSinCensurar.net',
        newsAuthor: 'Anónimo',
        newsDate: 'Hace 3 horas',
        newsTitle: '¡GOBIERNO OCULTA LA VERDAD!',
        newsContent:
            '¡LO QUE NO QUIEREN QUE SEPAS! Las antenas 5G están controlando nuestras mentes. ¡COMPARTE ANTES DE QUE BORREN ESTE MENSAJE! Solo los despiertos conocen la verdad. 👁️',
        newsShares: '45.8K compartidos',
        elements: [
          const QuizElement(
            id: 'true',
            text: 'Verdadero',
            icon: 'check_circle',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'false',
            text: 'Falso',
            icon: 'cancel',
            isCorrect: true,
          ),
        ],
        explanation:
            '¡Correcto! Esta es una teoría de conspiración FALSA. El autor anónimo, lenguaje alarmista y falta de evidencia son señales claras de desinformación.',
        type: QuestionType.trueFalse,
        correctAnswer: false,
        clues: [
          'Teoría de conspiración sin evidencia',
          'Presión para compartir: "ANTES DE QUE BORREN"',
          'Autor anónimo sin credenciales',
          'Lenguaje alarmista y mayúsculas excesivas',
        ],
      ),
    ];
  }
}
