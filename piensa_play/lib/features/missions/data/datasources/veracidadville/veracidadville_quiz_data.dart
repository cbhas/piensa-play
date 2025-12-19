import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_question.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_element.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/question_type.dart';

class VeracidadvilleQuizData {
  static List<QuizQuestion> getQuestions() {
    return [
      // Question 1: Jugo de Zanahoria
      QuizQuestion(
        id: 'q1_zanahoria',
        newsTitle:
            'Científicos descubren que beber jugo de zanahoria hace que puedas ver en la oscuridad',
        newsContent:
            'Según un estudio reciente, beber un vaso de jugo de zanahoria diariamente durante 30 días permite desarrollar visión nocturna similar a la de los gatos.',
        newsSource: 'ElNoticiero.com',
        newsDate: 'Publicado: Hoy',
        newsAuthor: 'Por: Dr. Inventado',
        newsShares: 'Compartido: 15,432 veces',
        newsImage: null,
        elements: [
          const QuizElement(
            id: 'author',
            text: 'Autor: ¿No es un experto real?',
            icon: 'person',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'source',
            text: 'Fuente: ¿Es falsa?',
            icon: 'link',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'image',
            text: 'Imagen: ¿Parece manipulada?',
            icon: 'image',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'data',
            text: 'Datos: ¿Son exagerados?',
            icon: 'trending_up',
            isCorrect: true,
          ),
        ],
        explanation:
            '¡Correcto! Esta noticia es falsa. El autor "Dr. Inventado" no es real, la fuente no es confiable, y los datos son exagerados. Las zanahorias ayudan a la salud visual pero no dan visión nocturna.',
        type: QuestionType.quiz, // Quiz type
      ),

      // Question 2: Vacunas y Superpoderes
      QuizQuestion(
        id: 'q2_vacunas',
        newsTitle:
            '¡URGENTE! Vacunas causan superpoderes en niños, dice estudio',
        newsContent:
            'Un grupo de científicos anónimos reveló que las vacunas están diseñadas para dar superpoderes a los niños. ¡Comparte antes de que lo borren!',
        newsSource: 'NoticiasTotales.net',
        newsDate: 'Publicado: Hace 2 horas',
        newsAuthor: 'Por: Anónimo',
        newsShares: 'Compartido: 50,000 veces',
        newsImage: null,
        elements: [
          const QuizElement(
            id: 'author',
            text: 'Autor: ¿No es un experto real?',
            icon: 'person',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'source',
            text: 'Fuente: ¿Es falsa?',
            icon: 'link',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'image',
            text: 'Imagen: ¿Parece manipulada?',
            icon: 'image',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'data',
            text: 'Datos: ¿Son exagerados?',
            icon: 'trending_up',
            isCorrect: true,
          ),
        ],
        explanation:
            '¡Correcto! Esta es una noticia falsa peligrosa. El autor es anónimo (no confiable), la fuente no es verificada, y la afirmación de "superpoderes" es completamente falsa. Las vacunas salvan vidas, no dan superpoderes.',
        type: QuestionType.quiz,
      ),

      // Question 3: Agua de Mar
      QuizQuestion(
        id: 'q3_agua_mar',
        newsTitle:
            'Médicos ocultan la verdad: beber agua de mar cura todas las enfermedades',
        newsContent:
            'La industria farmacéutica no quiere que sepas esto: el agua de mar puede curar cáncer, diabetes y hasta el resfriado común. Miles de personas ya lo probaron.',
        newsSource: 'SaludAlternativa.blog',
        newsDate: 'Publicado: Ayer',
        newsAuthor: 'Por: Naturista123',
        newsShares: 'Compartido: 25,678 veces',
        newsImage: null,
        elements: [
          const QuizElement(
            id: 'author',
            text: 'Autor: ¿No es un experto real?',
            icon: 'person',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'source',
            text: 'Fuente: ¿Es falsa?',
            icon: 'link',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'image',
            text: 'Imagen: ¿Parece manipulada?',
            icon: 'image',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'data',
            text: 'Datos: ¿Son exagerados?',
            icon: 'trending_up',
            isCorrect: true,
          ),
        ],
        explanation:
            '¡Correcto! Esta noticia es falsa y peligrosa. "Naturista123" no es un médico, la fuente es un blog no verificado, y afirmar que algo "cura todo" es una señal clara de información falsa. Beber agua de mar es peligroso.',
        type: QuestionType.quiz,
      ),
    ];
  }

  static const String quizTitle = 'Veracidadville';
  static const String quizSubtitle = 'Verifica o Falla';

  static const List<String> instructions = [
    'Lee la noticia o información presentada',
    'Analiza los elementos sospechosos',
    'Enlista los elementos identificados',
  ];

  static const String instructionHint =
      'Busca pistas en: fuentes, autores e imágenes';
}
