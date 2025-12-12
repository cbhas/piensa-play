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
  final String text;
  final bool isInclusive;
  final String replacement;
  final String hint;

  const StereotypeStatement({
    required this.text,
    required this.isInclusive,
    required this.replacement,
    required this.hint,
  });
}

class StereotypeScene {
  final String title;
  final String description;
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
        title: 'En el parque',
        description:
            'Mira quién juega. Cambia ideas que dejen a alguien fuera.',
        statements: const [
          StereotypeStatement(
            text: 'Niña jugando con muñecas',
            isInclusive: false,
            replacement: 'Niñas y niños pueden jugar con lo que quieran',
            hint: 'Los juguetes son para todos.',
          ),
          StereotypeStatement(
            text: 'Niño jugando fútbol',
            isInclusive: false,
            replacement: 'Todos pueden jugar fútbol si quieren',
            hint: 'El deporte es para divertirse.',
          ),
          StereotypeStatement(
            text: 'Niños y niñas leyendo juntos',
            isInclusive: true,
            replacement: 'Niños y niñas leyendo juntos',
            hint: 'Leer en equipo ya es inclusivo.',
          ),
        ],
      ),
      StereotypeScene(
        title: 'En la escuela',
        description:
            'Mira el salón y elige palabras que incluyan a todos.',
        statements: const [
          StereotypeStatement(
            text: 'Solo los grandes pueden liderar el equipo',
            isInclusive: false,
            replacement: 'Cualquiera puede liderar si escucha y apoya',
            hint: 'Liderar es compartir, no mandar.',
          ),
          StereotypeStatement(
            text: 'Todos pueden opinar y participar',
            isInclusive: true,
            replacement: 'Todos pueden opinar y participar',
            hint: 'La voz de todos suma.',
          ),
          StereotypeStatement(
            text: 'Los chicos no lloran',
            isInclusive: false,
            replacement: 'Sentir y llorar es para todos',
            hint: 'Sentir no tiene género.',
          ),
        ],
      ),
      StereotypeScene(
        title: 'En casa',
        description:
            'Haz que las tareas sean justas y todos ayuden.',
        statements: const [
          StereotypeStatement(
            text: 'Solo mamá cocina',
            isInclusive: false,
            replacement: 'Cocinar es para quien quiera ayudar',
            hint: 'Cuidar es tarea de todos.',
          ),
          StereotypeStatement(
            text: 'Todos ordenan sus cosas',
            isInclusive: true,
            replacement: 'Todos ordenan sus cosas',
            hint: 'Compartir tareas es justo.',
          ),
          StereotypeStatement(
            text: 'Los niños no ponen la mesa',
            isInclusive: false,
            replacement: 'Poner la mesa es trabajo en equipo',
            hint: 'Cooperar hace la casa feliz.',
          ),
        ],
      ),
    ];
  }
}
