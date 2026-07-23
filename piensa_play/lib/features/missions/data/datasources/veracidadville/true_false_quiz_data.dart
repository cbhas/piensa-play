import '../../../domain/entities/veracidadville/quiz_question.dart';
import '../../../domain/entities/veracidadville/quiz_element.dart';
import '../../../domain/entities/veracidadville/question_type.dart';
import '../../../../../core/localization/localized_text.dart';

class TrueFalseQuizData {
  static const LocalizedText quizTitle = LocalizedText(
    es: 'Veracidadville',
    en: 'Veracidadville',
  );
  static const LocalizedText quizSubtitle = LocalizedText(
    es: 'Detecta Fake News',
    en: 'Spot Fake News',
  );

  static List<QuizQuestion> getQuestions() {
    return [
      // Question 1: Magic cold cure (FALSE)
      QuizQuestion(
        id: 'tf_q1',
        newsSource: const LocalizedText(
          es: 'SaludTotal.com',
          en: 'SaludTotal.com',
        ),
        newsAuthor: const LocalizedText(
          es: '@SuperSaludable',
          en: '@SuperHealthy',
        ),
        newsDate: const LocalizedText(es: 'Hace 2 horas', en: '2 hours ago'),
        newsTitle: const LocalizedText(
          es: '¡CURA MÁGICA PARA EL RESFRIADO!',
          en: 'MAGIC CURE FOR THE COMMON COLD!',
        ),
        newsContent: const LocalizedText(
          es: 'Científicos descubren que beber agua con limón y miel ¡ELIMINA INSTANTÁNEAMENTE CUALQUIER VIRUS! Compartir con todos tus contactos para protegerlos. 🍋',
          en: 'Scientists discover that drinking water with lemon and honey INSTANTLY WIPES OUT ANY VIRUS! Share with all your contacts to protect them. 🍋',
        ),
        newsShares: const LocalizedText(
          es: '15.2K compartidos',
          en: '15.2K shares',
        ),
        elements: [
          const QuizElement(
            id: 'true',
            text: LocalizedText(es: 'Verdadero', en: 'True'),
            icon: 'check_circle',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'false',
            text: LocalizedText(es: 'Falso', en: 'False'),
            icon: 'cancel',
            isCorrect: true,
          ),
        ],
        explanation: const LocalizedText(
          es: '¡Correcto! Esta noticia es FALSA. El lenguaje exagerado, la falta de fuentes verificables y la presión para compartir son señales claras de desinformación.',
          en: 'Correct! This story is FALSE. The exaggerated language, lack of verifiable sources, and pressure to share are all clear signs of misinformation.',
        ),
        type: QuestionType.trueFalse,
        correctAnswer: false,
        clues: const [
          LocalizedText(
            es: 'Lenguaje exagerado: "ELIMINA INSTANTÁNEAMENTE"',
            en: 'Exaggerated language: "INSTANTLY WIPES OUT"',
          ),
          LocalizedText(
            es: 'Amenaza o presión: "Compartir o podrías enfermar"',
            en: 'Pressure tactic: "Share or you could get sick"',
          ),
          LocalizedText(
            es: 'Falta de fuentes científicas verificables',
            en: 'No verifiable scientific sources',
          ),
          LocalizedText(
            es: 'Uso de mayúsculas y signos de exclamación excesivos',
            en: 'Excessive use of capital letters and exclamation marks',
          ),
        ],
      ),

      // Question 2: Real scientific discovery (TRUE)
      QuizQuestion(
        id: 'tf_q2',
        newsSource: const LocalizedText(
          es: 'CienciaHoy.edu',
          en: 'CienciaHoy.edu',
        ),
        newsAuthor: const LocalizedText(
          es: 'Dr. María González',
          en: 'Dr. María González',
        ),
        newsDate: const LocalizedText(es: 'Hace 1 día', en: '1 day ago'),
        newsTitle: const LocalizedText(
          es: 'Estudio revela beneficios del ejercicio regular',
          en: 'Study reveals the benefits of regular exercise',
        ),
        newsContent: const LocalizedText(
          es: 'Investigadores de la Universidad Nacional publicaron un estudio en la revista médica "The Lancet" que muestra cómo 30 minutos de ejercicio diario pueden mejorar la salud cardiovascular. El estudio incluyó 5,000 participantes durante 2 años.',
          en: 'Researchers from the National University published a study in the medical journal "The Lancet" showing how 30 minutes of daily exercise can improve heart health. The study included 5,000 participants over 2 years.',
        ),
        newsShares: const LocalizedText(
          es: '2.3K compartidos',
          en: '2.3K shares',
        ),
        elements: [
          const QuizElement(
            id: 'true',
            text: LocalizedText(es: 'Verdadero', en: 'True'),
            icon: 'check_circle',
            isCorrect: true,
          ),
          const QuizElement(
            id: 'false',
            text: LocalizedText(es: 'Falso', en: 'False'),
            icon: 'cancel',
            isCorrect: false,
          ),
        ],
        explanation: const LocalizedText(
          es: '¡Correcto! Esta noticia es VERDADERA. Tiene fuentes verificables, datos específicos y lenguaje profesional. Es información confiable.',
          en: 'Correct! This story is TRUE. It has verifiable sources, specific data, and professional language. It\'s reliable information.',
        ),
        type: QuestionType.trueFalse,
        correctAnswer: true,
        clues: const [
          LocalizedText(
            es: 'Fuente verificable: Universidad Nacional',
            en: 'Verifiable source: National University',
          ),
          LocalizedText(
            es: 'Publicación en revista científica reconocida',
            en: 'Published in a recognized scientific journal',
          ),
          LocalizedText(
            es: 'Datos específicos: 5,000 participantes, 2 años',
            en: 'Specific data: 5,000 participants, 2 years',
          ),
          LocalizedText(
            es: 'Lenguaje moderado y profesional',
            en: 'Measured, professional language',
          ),
        ],
      ),

      // Question 3: Conspiracy theory (FALSE)
      QuizQuestion(
        id: 'tf_q3',
        newsSource: const LocalizedText(
          es: 'NoticiasSinCensurar.net',
          en: 'NoticiasSinCensurar.net',
        ),
        newsAuthor: const LocalizedText(es: 'Anónimo', en: 'Anonymous'),
        newsDate: const LocalizedText(es: 'Hace 3 horas', en: '3 hours ago'),
        newsTitle: const LocalizedText(
          es: '¡GOBIERNO OCULTA LA VERDAD!',
          en: 'GOVERNMENT IS HIDING THE TRUTH!',
        ),
        newsContent: const LocalizedText(
          es: '¡LO QUE NO QUIEREN QUE SEPAS! Las antenas 5G están controlando nuestras mentes. ¡COMPARTE ANTES DE QUE BORREN ESTE MENSAJE! Solo los despiertos conocen la verdad. 👁️',
          en: 'WHAT THEY DON\'T WANT YOU TO KNOW! 5G towers are controlling our minds. SHARE BEFORE THEY DELETE THIS MESSAGE! Only the woke ones know the truth. 👁️',
        ),
        newsShares: const LocalizedText(
          es: '45.8K compartidos',
          en: '45.8K shares',
        ),
        elements: [
          const QuizElement(
            id: 'true',
            text: LocalizedText(es: 'Verdadero', en: 'True'),
            icon: 'check_circle',
            isCorrect: false,
          ),
          const QuizElement(
            id: 'false',
            text: LocalizedText(es: 'Falso', en: 'False'),
            icon: 'cancel',
            isCorrect: true,
          ),
        ],
        explanation: const LocalizedText(
          es: '¡Correcto! Esta es una teoría de conspiración FALSA. El autor anónimo, lenguaje alarmista y falta de evidencia son señales claras de desinformación.',
          en: 'Correct! This is a FALSE conspiracy theory. The anonymous author, alarmist language, and lack of evidence are all clear signs of misinformation.',
        ),
        type: QuestionType.trueFalse,
        correctAnswer: false,
        clues: const [
          LocalizedText(
            es: 'Teoría de conspiración sin evidencia',
            en: 'Conspiracy theory with no evidence',
          ),
          LocalizedText(
            es: 'Presión para compartir: "ANTES DE QUE BORREN"',
            en: 'Pressure to share: "BEFORE THEY DELETE THIS"',
          ),
          LocalizedText(
            es: 'Autor anónimo sin credenciales',
            en: 'Anonymous author with no credentials',
          ),
          LocalizedText(
            es: 'Lenguaje alarmista y mayúsculas excesivas',
            en: 'Alarmist language and excessive capital letters',
          ),
        ],
      ),
    ];
  }
}
