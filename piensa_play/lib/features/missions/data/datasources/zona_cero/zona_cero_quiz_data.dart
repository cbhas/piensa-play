import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../../domain/entities/veracidadville/quiz_element.dart';
import '../../../domain/entities/veracidadville/question_type.dart';

class ZonaCeroQuizData {
  // Word Trail - Mensaje Escondido
  static final List<QuizQuestion> wordTrailQuestions = [
    QuizQuestion(
      id: 'zc_word_1',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Vuelve a tu país, nadie te quiere aquí.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation:
          'Todos merecen sentirse bienvenidos sin importar de dónde vienen.',
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_2',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Eres parte de nuestro equipo, contamos contigo.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation:
          'Las palabras que animan hacen que todos se sientan seguros.',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_3',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Hablas raro, no te entiendo.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: 'Burlarse lastima. Mejor pregunta con cariño para entender.',
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_4',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Gracias por compartir tu cultura con nosotros.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: 'Agradecer y escuchar crea amistad.',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_5',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'No puedes jugar, esto no es para ti.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: 'Todos pueden jugar. Invitar hace que nadie se quede solo.',
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_6',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Tu idea es genial, cuéntame más.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: 'Animar a otros ayuda a que sus ideas crezcan.',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_7',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Nadie quiere sentarse contigo.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: 'Dejar a alguien fuera duele. Invitar hace sentir bien.',
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_8',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Me gusta aprender palabras nuevas de ti.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: 'Aprender del otro nos une.',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_9',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Eres muy raro.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation:
          'Etiquetar lastima. Podemos decir: "Eres único y eso es genial".',
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_10',
      newsTitle: 'Mensaje Escondido',
      newsContent: 'Todos somos bienvenidos en este juego.',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'harmful',
          text: 'Dañino',
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: 'No Dañino',
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: 'Cuando incluimos a todos, el lugar se vuelve feliz.',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
  ];

  // Stereotypes - Rompe Estereotipos
  static final List<QuizQuestion> stereotypeQuestions = [
    QuizQuestion(
      id: 'zc_stereo_1',
      newsTitle: 'En el parque',
      newsContent: 'Niña jugando con muñecas',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'inclusive',
          text: 'Inclusivo',
          icon: 'check_circle',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'not_inclusive',
          text: 'No Inclusivo',
          icon: 'block',
          isCorrect: true,
        ),
      ],
      explanation:
          'Los juguetes son para todos. Mejor: "Niñas y niños pueden jugar con lo que quieran"',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_stereo_2',
      newsTitle: 'En la escuela',
      newsContent: 'Todos pueden opinar y participar',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'inclusive',
          text: 'Inclusivo',
          icon: 'check_circle',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'not_inclusive',
          text: 'No Inclusivo',
          icon: 'block',
          isCorrect: false,
        ),
      ],
      explanation: 'La voz de todos suma.',
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_stereo_3',
      newsTitle: 'En casa',
      newsContent: 'Solo mamá cocina',
      newsSource: 'Zona Cero Odio',
      newsDate: '',
      newsAuthor: '',
      newsShares: '',
      elements: [
        const QuizElement(
          id: 'inclusive',
          text: 'Inclusivo',
          icon: 'check_circle',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'not_inclusive',
          text: 'No Inclusivo',
          icon: 'block',
          isCorrect: true,
        ),
      ],
      explanation:
          'Cuidar es tarea de todos. Mejor: "Cocinar es para quien quiera ayudar"',
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
  ];

  static const String wordTrailTitle = 'Zona Cero Odio';
  static const String wordTrailSubtitle = 'El Mensaje Escondido';

  static const String stereotypeTitle = 'Zona Cero Odio';
  static const String stereotypeSubtitle = 'Rompe Estereotipos';
}
