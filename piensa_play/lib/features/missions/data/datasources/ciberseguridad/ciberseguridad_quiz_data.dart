import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_question.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/quiz_element.dart';
import 'package:piensa_play/features/missions/domain/entities/veracidadville/question_type.dart';
import 'package:piensa_play/core/localization/localized_text.dart';

class CiberseguridadQuizData {
  static final List<QuizQuestion> _questions = [
    // Question 1: Phishing Email
    QuizQuestion(
      id: 'q1_phishing',
      newsTitle: const LocalizedText(
        es: '¡Urgente! Actualiza tu información bancaria',
        en: 'Urgent! Update your banking information',
      ),
      newsContent: const LocalizedText(
        es: 'Hemos detectado actividad sospechosa en tu cuenta. Por favor, haz clic aquí y actualiza tu información inmediatamente para evitar el bloqueo.',
        en: 'We\'ve detected suspicious activity on your account. Please click here and update your information immediately to avoid being locked out.',
      ),
      newsSource: const LocalizedText(es: 'BancoFalso.com', en: 'FakeBank.com'),
      newsDate: const LocalizedText(es: 'Publicado: Hoy', en: 'Posted: Today'),
      newsAuthor: const LocalizedText(
        es: 'Departamento de Seguridad',
        en: 'Security Department',
      ),
      newsShares: const LocalizedText(
        es: 'Compartido: 123 veces',
        en: 'Shared: 123 times',
      ),
      newsImage: null,
      elements: [
        const QuizElement(
          id: 'urgency',
          text: LocalizedText(
            es: '¿El mensaje crea sensación de urgencia?',
            en: 'Does the message create a sense of urgency?',
          ),
          icon: 'alarm',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'sender',
          text: LocalizedText(
            es: '¿El remitente es desconocido o sospechoso?',
            en: 'Is the sender unknown or suspicious?',
          ),
          icon: 'person',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'link',
          text: LocalizedText(
            es: '¿El enlace parece sospechoso?',
            en: 'Does the link look suspicious?',
          ),
          icon: 'link',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: '¡Correcto! Este es un intento de phishing. Los correos urgentes, de remitentes desconocidos y con enlaces sospechosos suelen ser fraudulentos.',
        en: 'Correct! This is a phishing attempt. Urgent emails from unknown senders with suspicious links are usually fraudulent.',
      ),
      type: QuestionType.quiz,
    ),

    // Question 2: Malware Download
    QuizQuestion(
      id: 'q2_malware',
      newsTitle: const LocalizedText(
        es: 'Descarga gratis el nuevo juego [Nombre del Juego] ¡Edición Limitada!',
        en: 'Download the new [Game Name] for free — Limited Edition!',
      ),
      newsContent: const LocalizedText(
        es: '¡Sé el primero en jugar el nuevo [Nombre del Juego]! Descárgalo ahora desde nuestro sitio web.',
        en: 'Be the first to play the new [Game Name]! Download it now from our website.',
      ),
      newsSource: const LocalizedText(
        es: 'SitioWebDeJuegosFalsos.com',
        en: 'TotallyRealGamesSite.com',
      ),
      newsDate: const LocalizedText(
        es: 'Publicado: Ayer',
        en: 'Posted: Yesterday',
      ),
      newsAuthor: const LocalizedText(
        es: 'Equipo de Desarrollo',
        en: 'Development Team',
      ),
      newsShares: const LocalizedText(
        es: 'Compartido: 456 veces',
        en: 'Shared: 456 times',
      ),
      newsImage: null,
      elements: [
        const QuizElement(
          id: 'source',
          text: LocalizedText(
            es: '¿La fuente es desconocida o no oficial?',
            en: 'Is the source unknown or unofficial?',
          ),
          icon: 'link',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'free',
          text: LocalizedText(
            es: '¿Ofrecen algo gratis que normalmente cuesta dinero?',
            en: 'Are they offering something free that usually costs money?',
          ),
          icon: 'attach_money',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'permissions',
          text: LocalizedText(
            es: '¿El juego pide permisos extraños al instalarse?',
            en: 'Does the game ask for strange permissions when installing?',
          ),
          icon: 'security',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: '¡Correcto! Este podría ser un intento de distribuir malware. Descargar software de fuentes no oficiales es peligroso.',
        en: 'Correct! This could be an attempt to spread malware. Downloading software from unofficial sources is risky.',
      ),
      type: QuestionType.quiz,
    ),

    // Question 3: Password Strength
    QuizQuestion(
      id: 'q3_passwords',
      newsTitle: const LocalizedText(
        es: '¡Tu contraseña es tu llave!',
        en: 'Your password is your key!',
      ),
      newsContent: const LocalizedText(
        es: '¿Usas la misma contraseña para todo? ¡Es hora de cambiar eso! Una contraseña segura debe ser larga, aleatoria y única.',
        en: 'Do you use the same password for everything? It\'s time to change that! A strong password should be long, random, and unique.',
      ),
      newsSource: const LocalizedText(
        es: 'BlogDeSeguridad.net',
        en: 'SecurityBlog.net',
      ),
      newsDate: const LocalizedText(
        es: 'Publicado: Hace 1 semana',
        en: 'Posted: 1 week ago',
      ),
      newsAuthor: const LocalizedText(
        es: 'ExpertoEnSeguridad',
        en: 'SecurityExpert',
      ),
      newsShares: const LocalizedText(
        es: 'Compartido: 789 veces',
        en: 'Shared: 789 times',
      ),
      newsImage: null,
      elements: [
        const QuizElement(
          id: 'length',
          text: LocalizedText(
            es: '¿La contraseña tiene menos de 8 caracteres?',
            en: 'Is the password shorter than 8 characters?',
          ),
          icon: 'text_fields',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'reuse',
          text: LocalizedText(
            es: '¿La usas en múltiples sitios web?',
            en: 'Do you use it on multiple websites?',
          ),
          icon: 'repeat',
          isCorrect: true,
        ),
        const QuizElement(
          id: 'personal',
          text: LocalizedText(
            es: '¿Contiene información personal fácil de adivinar?',
            en: 'Does it contain personal information that\'s easy to guess?',
          ),
          icon: 'person',
          isCorrect: true,
        ),
      ],
      explanation: const LocalizedText(
        es: '¡Correcto! Usar contraseñas débiles es un riesgo. Asegúrate de crear contraseñas fuertes y únicas para cada cuenta.',
        en: 'Correct! Using weak passwords is risky. Make sure to create strong, unique passwords for every account.',
      ),
      type: QuestionType.quiz,
    ),
  ];

  static List<QuizQuestion> getQuestions() {
    return _questions;
  }

  static QuizQuestion? getQuestionById(String id) {
    return _questions.firstWhere((q) => q.id == id);
  }

  static const LocalizedText quizTitle = LocalizedText(
    es: 'Misión Ciberseguridad',
    en: 'Cybersecurity Mission',
  );
  static const LocalizedText quizSubtitle = LocalizedText(
    es: 'Defiende tus Datos',
    en: 'Defend Your Data',
  );

  static const List<LocalizedText> instructions = [
    LocalizedText(
      es: 'Lee la situación o noticia presentada',
      en: 'Read the situation or news shown',
    ),
    LocalizedText(
      es: 'Analiza los elementos de riesgo',
      en: 'Analyze the risk elements',
    ),
    LocalizedText(
      es: 'Identifica las posibles amenazas',
      en: 'Identify the possible threats',
    ),
  ];

  static const LocalizedText instructionHint = LocalizedText(
    es: 'Busca pistas en: enlaces, remitentes y permisos',
    en: 'Look for clues in: links, senders, and permissions',
  );
}
