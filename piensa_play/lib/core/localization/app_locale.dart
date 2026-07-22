import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ChangeNotifier {
  static const _preferenceKey = 'app_language';
  Locale _locale = const Locale('es');

  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == 'en';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_preferenceKey);
    if (code == 'en' || code == 'es') {
      _locale = Locale(code!);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!const ['es', 'en'].contains(locale.languageCode)) return;
    _locale = Locale(locale.languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferenceKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> toggle() => setLocale(
    _locale.languageCode == 'es' ? const Locale('en') : const Locale('es'),
  );
}

class AppStrings {
  final String languageCode;
  const AppStrings(this.languageCode);

  static AppStrings of(BuildContext context) =>
      AppStrings(Localizations.localeOf(context).languageCode);

  String t(String key, [Map<String, Object> values = const {}]) {
    var value = (_values[languageCode] ?? _values['es']!)[key] ?? key;
    for (final entry in values.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value.toString());
    }
    return value;
  }

  static const Map<String, Map<String, String>> _values = {
    'es': {
      'appName': 'PiensaPlay',
      'tagline': 'Cada clic puede cambiar el mundo',
      'welcomeTitle': 'Entrena tu mente digital',
      'welcomeBody':
          'Explora una ciudad donde tus decisiones pueden frenar rumores, proteger personas y recuperar la confianza.',
      'startAdventure': 'Crear mi aventura',
      'tryDemo': 'Probar demo de 3 minutos',
      'language': 'Idioma',
      'spanish': 'Español',
      'english': 'English',
      'privacyNote':
          'Sin anuncios. Tus datos personales no son parte del juego.',
      'hello': 'Hola, {name}',
      'homeQuestion': '¿Qué vas a cambiar hoy?',
      'continueMission': 'Continuar la misión',
      'enterCity': 'Entrar a la Ciudad Digital',
      'methodTitle': 'Tu superpoder: PIENSA',
      'methodBody': 'Pausa · Identifica · Examina · Nota · Busca · Actúa',
      'dailyChallenge': 'Desafío diario',
      'dailyReady': 'Una decisión rápida para mantener tu mente alerta',
      'progress': 'Progreso',
      'missions': 'Misiones',
      'learn': 'Aprende',
      'achievements': 'Logros',
      'glossary': 'Glosario',
      'settings': 'Ajustes',
      'cityTitle': 'Ciudad Digital',
      'citySubtitle': 'Recupera la confianza, una decisión a la vez.',
      'trust': 'Confianza de la ciudad',
      'completed': 'Completada',
      'locked': 'Completa la misión anterior',
      'start': 'Comenzar',
      'replay': 'Practicar de nuevo',
      'mission1Title': 'La publicación viral',
      'mission1Subtitle': 'Una alerta sin fuente recorre la escuela.',
      'mission2Title': 'El laboratorio de IA',
      'mission2Subtitle':
          'Una imagen perfecta puede ocultar una historia falsa.',
      'mission3Title': 'La onda de compartir',
      'mission3Subtitle': 'Tus acciones cambian lo que vive toda la comunidad.',
      'stepPause': 'Pausa',
      'stepIdentify': 'Identifica',
      'stepExamine': 'Examina',
      'stepNotice': 'Nota',
      'stepSeek': 'Busca',
      'stepAct': 'Actúa',
      'scenario': 'Escenario',
      'chooseAction': 'Elige la acción más responsable',
      'checkAnswer': 'Comprobar decisión',
      'continue': 'Continuar',
      'correct': 'Buena decisión',
      'tryAgain': 'Mira las pistas otra vez',
      'why': 'Por qué importa',
      'clues': 'Pistas para verificar',
      'resultTitle': '¡La ciudad confía más en ti!',
      'resultBody':
          'No solo acertaste: practicaste una habilidad que puedes usar fuera del juego.',
      'mastered': 'Habilidades practicadas',
      'backToCity': 'Volver a la ciudad',
      'nextMission': 'Siguiente misión',
      'demoComplete': 'Demo completada',
      'demoMessage': 'Aplicaste el método PIENSA a tres retos reales.',
      'classroom': 'Modo aula',
      'classroomBody':
          'Debatan, voten y expliquen la evidencia antes de revelar la respuesta.',
      'facilitator': 'Guía para facilitadores',
      'accessibility': 'Accesibilidad',
      'reducedMotion': 'Reducir movimiento',
      'largeText': 'Texto más grande',
      'offlineReady': 'Disponible sin conexión',
      'evidence': 'Evidencia',
      'impact': 'Impacto de aprendizaje',
    },
    'en': {
      'appName': 'PiensaPlay',
      'tagline': 'Every click can change the world',
      'welcomeTitle': 'Train your digital mind',
      'welcomeBody':
          'Explore a city where your choices can stop rumors, protect people and rebuild trust.',
      'startAdventure': 'Create my adventure',
      'tryDemo': 'Try the 3-minute demo',
      'language': 'Language',
      'spanish': 'Español',
      'english': 'English',
      'privacyNote': 'No ads. Your personal data is not part of the game.',
      'hello': 'Hello, {name}',
      'homeQuestion': 'What will you change today?',
      'continueMission': 'Continue mission',
      'enterCity': 'Enter Digital City',
      'methodTitle': 'Your superpower: PIENSA',
      'methodBody': 'Pause · Identify · Examine · Notice · Seek · Act',
      'dailyChallenge': 'Daily challenge',
      'dailyReady': 'One quick decision to keep your mind alert',
      'progress': 'Progress',
      'missions': 'Missions',
      'learn': 'Learn',
      'achievements': 'Achievements',
      'glossary': 'Glossary',
      'settings': 'Settings',
      'cityTitle': 'Digital City',
      'citySubtitle': 'Rebuild trust, one decision at a time.',
      'trust': 'City trust',
      'completed': 'Completed',
      'locked': 'Complete the previous mission',
      'start': 'Start',
      'replay': 'Practice again',
      'mission1Title': 'The viral post',
      'mission1Subtitle': 'A sourceless alert is spreading at school.',
      'mission2Title': 'The AI lab',
      'mission2Subtitle': 'A perfect image can hide a false story.',
      'mission3Title': 'The sharing ripple',
      'mission3Subtitle': 'Your actions reshape the whole community.',
      'stepPause': 'Pause',
      'stepIdentify': 'Identify',
      'stepExamine': 'Examine',
      'stepNotice': 'Notice',
      'stepSeek': 'Seek',
      'stepAct': 'Act',
      'scenario': 'Scenario',
      'chooseAction': 'Choose the most responsible action',
      'checkAnswer': 'Check decision',
      'continue': 'Continue',
      'correct': 'Good decision',
      'tryAgain': 'Look at the clues again',
      'why': 'Why it matters',
      'clues': 'Verification clues',
      'resultTitle': 'The city trusts you more!',
      'resultBody':
          'You did more than score points: you practiced a skill for real life.',
      'mastered': 'Skills practiced',
      'backToCity': 'Back to the city',
      'nextMission': 'Next mission',
      'demoComplete': 'Demo complete',
      'demoMessage':
          'You applied the PIENSA method to three real-world challenges.',
      'classroom': 'Classroom mode',
      'classroomBody':
          'Debate, vote and explain the evidence before revealing the answer.',
      'facilitator': 'Facilitator guide',
      'accessibility': 'Accessibility',
      'reducedMotion': 'Reduce motion',
      'largeText': 'Larger text',
      'offlineReady': 'Available offline',
      'evidence': 'Evidence',
      'impact': 'Learning impact',
    },
  };
}

extension AppStringsContext on BuildContext {
  AppStrings get strings => AppStrings.of(this);
}
