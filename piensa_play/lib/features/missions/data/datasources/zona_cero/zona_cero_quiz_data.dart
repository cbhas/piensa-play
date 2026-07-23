import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../../domain/entities/veracidadville/quiz_element.dart';
import '../../../domain/entities/veracidadville/question_type.dart';
import '../../../../../core/localization/localized_text.dart';

class ZonaCeroQuizData {
  // Word Trail - Hidden Message
  static final List<QuizQuestion> wordTrailQuestions = [
    QuizQuestion(
      id: 'zc_word_1',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Vuelve a tu país, nadie te quiere aquí.',
        en: 'Go back to your country, nobody wants you here.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Todos merecen sentirse bienvenidos sin importar de dónde vienen.',
        en: 'Everyone deserves to feel welcome no matter where they\'re from.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_2',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Eres parte de nuestro equipo, contamos contigo.',
        en: 'You\'re part of our team, we count on you.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Las palabras que animan hacen que todos se sientan seguros.',
        en: 'Encouraging words help everyone feel safe.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_3',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Hablas raro, no te entiendo.',
        en: 'You talk weird, I can\'t understand you.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Burlarse lastima. Mejor pregunta con cariño para entender.',
        en: 'Making fun of someone hurts. It\'s kinder to ask, with care, so you can understand.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_4',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Gracias por compartir tu cultura con nosotros.',
        en: 'Thanks for sharing your culture with us.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Agradecer y escuchar crea amistad.',
        en: 'Saying thanks and listening builds friendship.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_5',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'No puedes jugar, esto no es para ti.',
        en: 'You can\'t play, this isn\'t for you.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Todos pueden jugar. Invitar hace que nadie se quede solo.',
        en: 'Everyone can play. Inviting others means nobody gets left out.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_6',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Tu idea es genial, cuéntame más.',
        en: 'Your idea is great, tell me more.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Animar a otros ayuda a que sus ideas crezcan.',
        en: 'Encouraging others helps their ideas grow.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_7',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Nadie quiere sentarse contigo.',
        en: 'Nobody wants to sit with you.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Dejar a alguien fuera duele. Invitar hace sentir bien.',
        en: 'Leaving someone out hurts. Inviting them in feels good.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_8',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Me gusta aprender palabras nuevas de ti.',
        en: 'I love learning new words from you.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Aprender del otro nos une.',
        en: 'Learning from each other brings us together.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_word_9',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(es: 'Eres muy raro.', en: 'You\'re so weird.'),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: false,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Etiquetar lastima. Podemos decir: "Eres único y eso es genial".',
        en: 'Labeling someone hurts. Instead we can say: "You\'re one of a kind, and that\'s awesome."',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_word_10',
      newsTitle: const LocalizedText(
        es: 'Mensaje Escondido',
        en: 'Hidden Message',
      ),
      newsContent: const LocalizedText(
        es: 'Todos somos bienvenidos en este juego.',
        en: 'Everyone is welcome in this game.',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'harmful',
          text: LocalizedText(es: 'Dañino', en: 'Harmful'),
          icon: 'block',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'safe',
          text: LocalizedText(es: 'No Dañino', en: 'Not Harmful'),
          icon: 'check_circle',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Cuando incluimos a todos, el lugar se vuelve feliz.',
        en: 'When we include everyone, this becomes a happier place.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
  ];

  // Stereotypes - Break Stereotypes
  static final List<QuizQuestion> stereotypeQuestions = [
    QuizQuestion(
      id: 'zc_stereo_1',
      newsTitle: const LocalizedText(es: 'En el parque', en: 'At the park'),
      newsContent: const LocalizedText(
        es: 'Niña jugando con muñecas',
        en: 'A girl playing with dolls',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'inclusive',
          text: LocalizedText(es: 'Inclusivo', en: 'Inclusive'),
          icon: 'check_circle',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'not_inclusive',
          text: LocalizedText(es: 'No Inclusivo', en: 'Not Inclusive'),
          icon: 'block',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es:
            'Los juguetes son para todos. Mejor: "Niñas y niños pueden jugar con lo que quieran"',
        en:
            'Toys are for everyone. Better: "Girls and boys can play with whatever they like"',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
    QuizQuestion(
      id: 'zc_stereo_2',
      newsTitle: const LocalizedText(
        es: 'En la escuela',
        en: 'At school',
      ),
      newsContent: const LocalizedText(
        es: 'Todos pueden opinar y participar',
        en: 'Everyone can share their opinion and take part',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'inclusive',
          text: LocalizedText(es: 'Inclusivo', en: 'Inclusive'),
          icon: 'check_circle',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'not_inclusive',
          text: LocalizedText(es: 'No Inclusivo', en: 'Not Inclusive'),
          icon: 'block',
          isCorrect: false,
        ),
      ],
      explanation: const LocalizedText(
        es: 'La voz de todos suma.',
        en: 'Everyone\'s voice matters.',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: true,
    ),
    QuizQuestion(
      id: 'zc_stereo_3',
      newsTitle: const LocalizedText(es: 'En casa', en: 'At home'),
      newsContent: const LocalizedText(
        es: 'Solo mamá cocina',
        en: 'Only mom cooks',
      ),
      newsSource: const LocalizedText(
        es: 'Zona Cero Odio',
        en: 'Zero Hate Zone',
      ),
      newsDate: const LocalizedText(es: '', en: ''),
      newsAuthor: const LocalizedText(es: '', en: ''),
      newsShares: const LocalizedText(es: '', en: ''),
      elements: [
        const QuizElement(
          id: 'inclusive',
          text: LocalizedText(es: 'Inclusivo', en: 'Inclusive'),
          icon: 'check_circle',
          isCorrect: false,
        ),
        const QuizElement(
          id: 'not_inclusive',
          text: LocalizedText(es: 'No Inclusivo', en: 'Not Inclusive'),
          icon: 'block',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: 'Cuidar es tarea de todos. Mejor: "Cocinar es para quien quiera ayudar"',
        en: 'Caregiving is everyone\'s job. Better: "Cooking is for whoever wants to help"',
      ),
      type: QuestionType.trueFalse,
      correctAnswer: false,
    ),
  ];

  static const LocalizedText wordTrailTitle = LocalizedText(
    es: 'Zona Cero Odio',
    en: 'Zero Hate Zone',
  );
  static const LocalizedText wordTrailSubtitle = LocalizedText(
    es: 'El Mensaje Escondido',
    en: 'The Hidden Message',
  );

  static const LocalizedText stereotypeTitle = LocalizedText(
    es: 'Zona Cero Odio',
    en: 'Zero Hate Zone',
  );
  static const LocalizedText stereotypeSubtitle = LocalizedText(
    es: 'Rompe Estereotipos',
    en: 'Break Stereotypes',
  );
}
