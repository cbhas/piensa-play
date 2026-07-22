import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_question.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_element.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/question_type.dart';
import 'package:piensa_play/core/localization/localized_text.dart';

class VeracidadvilleQuizData {
  static List<QuizQuestion> getQuestions() {
    return [
      // Question 1: Carrot Juice
      QuizQuestion(
        id: 'q1_zanahoria',
        newsTitle: const LocalizedText(
          es:
              'Científicos descubren que beber jugo de zanahoria hace que puedas ver en la oscuridad',
          en:
              'Scientists discover that drinking carrot juice lets you see in the dark',
        ),
        newsContent: const LocalizedText(
          es:
              'Según un estudio reciente, beber un vaso de jugo de zanahoria diariamente durante 30 días permite desarrollar visión nocturna similar a la de los gatos.',
          en:
              'According to a recent study, drinking a glass of carrot juice every day for 30 days lets you develop night vision just like a cat\'s.',
        ),
        newsSource: const LocalizedText(
          es: 'ElNoticiero.com',
          en: 'ElNoticiero.com',
        ),
        newsDate: const LocalizedText(
          es: 'Publicado: Hoy',
          en: 'Published: Today',
        ),
        newsAuthor: const LocalizedText(
          es: 'Por: Dr. Inventado',
          en: 'By: Dr. MadeUp',
        ),
        newsShares: const LocalizedText(
          es: 'Compartido: 15,432 veces',
          en: 'Shared: 15,432 times',
        ),
        newsImage: null,
        elements: [
          const QuizElement(
            id: 'author',
            text: LocalizedText(
              es: 'Autor: ¿No es un experto real?',
              en: 'Author: Not a real expert?',
            ),
            icon: 'person',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'source',
            text: LocalizedText(
              es: 'Fuente: ¿Es falsa?',
              en: 'Source: Is it fake?',
            ),
            icon: 'link',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'image',
            text: LocalizedText(
              es: 'Imagen: ¿Parece manipulada?',
              en: 'Image: Does it look manipulated?',
            ),
            icon: 'image',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'data',
            text: LocalizedText(
              es: 'Datos: ¿Son exagerados?',
              en: 'Data: Is it exaggerated?',
            ),
            icon: 'trending_up',
            isCorrect: true,
          ),
        ],
        explanation: const LocalizedText(
          es:
              '¡Correcto! Esta noticia es falsa. El autor "Dr. Inventado" no es real, la fuente no es confiable, y los datos son exagerados. Las zanahorias ayudan a la salud visual pero no dan visión nocturna.',
          en:
              'Correct! This story is fake. The author "Dr. MadeUp" isn\'t real, the source isn\'t trustworthy, and the claims are exaggerated. Carrots are good for your eyes, but they don\'t give you night vision.',
        ),
        type: QuestionType.quiz, // Quiz type
      ),

      // Question 2: Vaccines and Superpowers
      QuizQuestion(
        id: 'q2_vacunas',
        newsTitle: const LocalizedText(
          es: '¡URGENTE! Vacunas causan superpoderes en niños, dice estudio',
          en: 'URGENT! Vaccines give kids superpowers, study says',
        ),
        newsContent: const LocalizedText(
          es:
              'Un grupo de científicos anónimos reveló que las vacunas están diseñadas para dar superpoderes a los niños. ¡Comparte antes de que lo borren!',
          en:
              'A group of anonymous scientists revealed that vaccines are secretly designed to give kids superpowers. Share before they delete this!',
        ),
        newsSource: const LocalizedText(
          es: 'NoticiasTotales.net',
          en: 'NoticiasTotales.net',
        ),
        newsDate: const LocalizedText(
          es: 'Publicado: Hace 2 horas',
          en: 'Published: 2 hours ago',
        ),
        newsAuthor: const LocalizedText(es: 'Por: Anónimo', en: 'By: Anonymous'),
        newsShares: const LocalizedText(
          es: 'Compartido: 50,000 veces',
          en: 'Shared: 50,000 times',
        ),
        newsImage: null,
        elements: [
          const QuizElement(
            id: 'author',
            text: LocalizedText(
              es: 'Autor: ¿No es un experto real?',
              en: 'Author: Not a real expert?',
            ),
            icon: 'person',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'source',
            text: LocalizedText(
              es: 'Fuente: ¿Es falsa?',
              en: 'Source: Is it fake?',
            ),
            icon: 'link',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'image',
            text: LocalizedText(
              es: 'Imagen: ¿Parece manipulada?',
              en: 'Image: Does it look manipulated?',
            ),
            icon: 'image',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'data',
            text: LocalizedText(
              es: 'Datos: ¿Son exagerados?',
              en: 'Data: Is it exaggerated?',
            ),
            icon: 'trending_up',
            isCorrect: true,
          ),
        ],
        explanation: const LocalizedText(
          es:
              '¡Correcto! Esta es una noticia falsa peligrosa. El autor es anónimo (no confiable), la fuente no es verificada, y la afirmación de "superpoderes" es completamente falsa. Las vacunas salvan vidas, no dan superpoderes.',
          en:
              'Correct! This is a dangerous fake story. The author is anonymous (not trustworthy), the source isn\'t verified, and the "superpowers" claim is completely false. Vaccines save lives — they don\'t give superpowers.',
        ),
        type: QuestionType.quiz,
      ),

      // Question 3: Seawater
      QuizQuestion(
        id: 'q3_agua_mar',
        newsTitle: const LocalizedText(
          es:
              'Médicos ocultan la verdad: beber agua de mar cura todas las enfermedades',
          en: 'Doctors hide the truth: seawater cures every disease',
        ),
        newsContent: const LocalizedText(
          es:
              'La industria farmacéutica no quiere que sepas esto: el agua de mar puede curar cáncer, diabetes y hasta el resfriado común. Miles de personas ya lo probaron.',
          en:
              'The pharmaceutical industry doesn\'t want you to know this: seawater can cure cancer, diabetes, and even the common cold. Thousands of people have already tried it.',
        ),
        newsSource: const LocalizedText(
          es: 'SaludAlternativa.blog',
          en: 'SaludAlternativa.blog',
        ),
        newsDate: const LocalizedText(
          es: 'Publicado: Ayer',
          en: 'Published: Yesterday',
        ),
        newsAuthor: const LocalizedText(
          es: 'Por: Naturista123',
          en: 'By: NaturalHealer123',
        ),
        newsShares: const LocalizedText(
          es: 'Compartido: 25,678 veces',
          en: 'Shared: 25,678 times',
        ),
        newsImage: null,
        elements: [
          const QuizElement(
            id: 'author',
            text: LocalizedText(
              es: 'Autor: ¿No es un experto real?',
              en: 'Author: Not a real expert?',
            ),
            icon: 'person',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'source',
            text: LocalizedText(
              es: 'Fuente: ¿Es falsa?',
              en: 'Source: Is it fake?',
            ),
            icon: 'link',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'image',
            text: LocalizedText(
              es: 'Imagen: ¿Parece manipulada?',
              en: 'Image: Does it look manipulated?',
            ),
            icon: 'image',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'data',
            text: LocalizedText(
              es: 'Datos: ¿Son exagerados?',
              en: 'Data: Is it exaggerated?',
            ),
            icon: 'trending_up',
            isCorrect: true,
          ),
        ],
        explanation: const LocalizedText(
          es:
              '¡Correcto! Esta noticia es falsa y peligrosa. "Naturista123" no es un médico, la fuente es un blog no verificado, y afirmar que algo "cura todo" es una señal clara de información falsa. Beber agua de mar es peligroso.',
          en:
              'Correct! This story is fake and dangerous. "NaturalHealer123" isn\'t a doctor, the source is an unverified blog, and claiming something "cures everything" is a clear sign of misinformation. Drinking seawater is actually dangerous.',
        ),
        type: QuestionType.quiz,
      ),
    ];
  }

  static const LocalizedText quizTitle = LocalizedText(
    es: 'Veracidadville',
    en: 'Veracidadville',
  );
  static const LocalizedText quizSubtitle = LocalizedText(
    es: 'Verifica o Falla',
    en: 'Verify or Fail',
  );

  static const List<LocalizedText> instructions = [
    LocalizedText(
      es: 'Lee la noticia o información presentada',
      en: 'Read the news or information shown',
    ),
    LocalizedText(
      es: 'Analiza los elementos sospechosos',
      en: 'Analyze the suspicious elements',
    ),
    LocalizedText(
      es: 'Enlista los elementos identificados',
      en: 'List the elements you identified',
    ),
  ];

  static const LocalizedText instructionHint = LocalizedText(
    es: 'Busca pistas en: fuentes, autores e imágenes',
    en: 'Look for clues in: sources, authors, and images',
  );
}
