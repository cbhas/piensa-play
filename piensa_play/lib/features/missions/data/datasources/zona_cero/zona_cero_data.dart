import '../../../../../core/localization/localized_text.dart';

class WordTrailPhrase {
  final String phrase;
  final bool isHarmful;
  final String tip;

  const WordTrailPhrase({
    required this.phrase,
    required this.isHarmful,
    required this.tip,
  });
}

class StereotypeStatement {
  final LocalizedText text;
  final bool isInclusive;
  final LocalizedText replacement;
  final LocalizedText hint;

  const StereotypeStatement({
    required this.text,
    required this.isInclusive,
    required this.replacement,
    required this.hint,
  });
}

class StereotypeScene {
  final LocalizedText title;
  final LocalizedText description;
  final List<StereotypeStatement> statements;

  const StereotypeScene({
    required this.title,
    required this.description,
    required this.statements,
  });
}

class ZonaCeroData {
  static List<WordTrailPhrase> wordTrailPhrases() {
    return const [
      WordTrailPhrase(
        phrase: 'Vuelve a tu país, nadie te quiere aquí.',
        isHarmful: true,
        tip: 'Todos merecen sentirse bienvenidos sin importar de dónde vienen.',
      ),
      WordTrailPhrase(
        phrase: 'Eres parte de nuestro equipo, contamos contigo.',
        isHarmful: false,
        tip: 'Las palabras que animan hacen que todos se sientan seguros.',
      ),
      WordTrailPhrase(
        phrase: 'Hablas raro, no te entiendo.',
        isHarmful: true,
        tip: 'Burlarse lastima. Mejor pregunta con cariño para entender.',
      ),
      WordTrailPhrase(
        phrase: 'Gracias por compartir tu cultura con nosotros.',
        isHarmful: false,
        tip: 'Agradecer y escuchar crea amistad.',
      ),
      WordTrailPhrase(
        phrase: 'No puedes jugar, esto no es para ti.',
        isHarmful: true,
        tip: 'Todos pueden jugar. Invitar hace que nadie se quede solo.',
      ),
      WordTrailPhrase(
        phrase: 'Tu idea es genial, cuéntame más.',
        isHarmful: false,
        tip: 'Animar a otros ayuda a que sus ideas crezcan.',
      ),
      WordTrailPhrase(
        phrase: 'Nadie quiere sentarse contigo.',
        isHarmful: true,
        tip: 'Dejar a alguien fuera duele. Invitar hace sentir bien.',
      ),
      WordTrailPhrase(
        phrase: 'Me gusta aprender palabras nuevas de ti.',
        isHarmful: false,
        tip: 'Aprender del otro nos une.',
      ),
      WordTrailPhrase(
        phrase: 'Eres muy raro.',
        isHarmful: true,
        tip: 'Etiquetar lastima. Podemos decir: "Eres único y eso es genial".',
      ),
      WordTrailPhrase(
        phrase: 'Todos somos bienvenidos en este juego.',
        isHarmful: false,
        tip: 'Cuando incluimos a todos, el lugar se vuelve feliz.',
      ),
    ];
  }

  static List<StereotypeScene> stereotypeScenes() {
    return [
      StereotypeScene(
        title: const LocalizedText(es: 'En el parque', en: 'At the park'),
        description: const LocalizedText(
          es: 'Mira quién juega. Cambia ideas que dejen a alguien fuera.',
          en: 'Look at who is playing. Change ideas that leave someone out.',
        ),
        statements: const [
          StereotypeStatement(
            text: LocalizedText(
              es: 'Niña jugando con muñecas',
              en: 'A girl playing with dolls',
            ),
            isInclusive: false,
            replacement: LocalizedText(
              es: 'Niñas y niños pueden jugar con lo que quieran',
              en: 'Girls and boys can play with whatever they want',
            ),
            hint: LocalizedText(
              es: 'Los juguetes son para todos.',
              en: 'Toys are for everyone.',
            ),
          ),
          StereotypeStatement(
            text: LocalizedText(
              es: 'Niño jugando fútbol',
              en: 'A boy playing soccer',
            ),
            isInclusive: false,
            replacement: LocalizedText(
              es: 'Todos pueden jugar fútbol si quieren',
              en: 'Anyone can play soccer if they want to',
            ),
            hint: LocalizedText(
              es: 'El deporte es para divertirse.',
              en: 'Sports are for having fun.',
            ),
          ),
          StereotypeStatement(
            text: LocalizedText(
              es: 'Niños y niñas leyendo juntos',
              en: 'Boys and girls reading together',
            ),
            isInclusive: true,
            replacement: LocalizedText(
              es: 'Niños y niñas leyendo juntos',
              en: 'Boys and girls reading together',
            ),
            hint: LocalizedText(
              es: 'Leer en equipo ya es inclusivo.',
              en: 'Reading as a team is already inclusive.',
            ),
          ),
        ],
      ),
      StereotypeScene(
        title: const LocalizedText(es: 'En la escuela', en: 'At school'),
        description: const LocalizedText(
          es: 'Mira el salón y elige palabras que incluyan a todos.',
          en: 'Look at the classroom and choose words that include everyone.',
        ),
        statements: const [
          StereotypeStatement(
            text: LocalizedText(
              es: 'Solo los grandes pueden liderar el equipo',
              en: 'Only the older kids can lead the team',
            ),
            isInclusive: false,
            replacement: LocalizedText(
              es: 'Cualquiera puede liderar si escucha y apoya',
              en: 'Anyone can lead if they listen and support others',
            ),
            hint: LocalizedText(
              es: 'Liderar es compartir, no mandar.',
              en: 'Leading is about sharing, not ordering.',
            ),
          ),
          StereotypeStatement(
            text: LocalizedText(
              es: 'Todos pueden opinar y participar',
              en: 'Everyone can share their opinion and take part',
            ),
            isInclusive: true,
            replacement: LocalizedText(
              es: 'Todos pueden opinar y participar',
              en: 'Everyone can share their opinion and take part',
            ),
            hint: LocalizedText(
              es: 'La voz de todos suma.',
              en: 'Everyone\'s voice matters.',
            ),
          ),
          StereotypeStatement(
            text: LocalizedText(
              es: 'Los chicos no lloran',
              en: 'Boys don\'t cry',
            ),
            isInclusive: false,
            replacement: LocalizedText(
              es: 'Sentir y llorar es para todos',
              en: 'Feeling and crying are for everyone',
            ),
            hint: LocalizedText(
              es: 'Sentir no tiene género.',
              en: 'Feelings have no gender.',
            ),
          ),
        ],
      ),
      StereotypeScene(
        title: const LocalizedText(es: 'En casa', en: 'At home'),
        description: const LocalizedText(
          es: 'Haz que las tareas sean justas y todos ayuden.',
          en: 'Make chores fair so everyone helps out.',
        ),
        statements: const [
          StereotypeStatement(
            text: LocalizedText(
              es: 'Solo mamá cocina',
              en: 'Only mom cooks',
            ),
            isInclusive: false,
            replacement: LocalizedText(
              es: 'Cocinar es para quien quiera ayudar',
              en: 'Cooking is for whoever wants to help',
            ),
            hint: LocalizedText(
              es: 'Cuidar es tarea de todos.',
              en: 'Caring is everyone\'s job.',
            ),
          ),
          StereotypeStatement(
            text: LocalizedText(
              es: 'Todos ordenan sus cosas',
              en: 'Everyone tidies up their own things',
            ),
            isInclusive: true,
            replacement: LocalizedText(
              es: 'Todos ordenan sus cosas',
              en: 'Everyone tidies up their own things',
            ),
            hint: LocalizedText(
              es: 'Compartir tareas es justo.',
              en: 'Sharing chores is fair.',
            ),
          ),
          StereotypeStatement(
            text: LocalizedText(
              es: 'Los niños no ponen la mesa',
              en: 'Boys don\'t set the table',
            ),
            isInclusive: false,
            replacement: LocalizedText(
              es: 'Poner la mesa es trabajo en equipo',
              en: 'Setting the table is teamwork',
            ),
            hint: LocalizedText(
              es: 'Cooperar hace la casa feliz.',
              en: 'Cooperating makes a happy home.',
            ),
          ),
        ],
      ),
    ];
  }
}
