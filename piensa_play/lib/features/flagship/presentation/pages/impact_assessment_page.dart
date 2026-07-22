import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/flagship_progress_service.dart';
import '../../domain/flagship_mission.dart';

class ImpactAssessmentPage extends StatefulWidget {
  final bool isPost;
  const ImpactAssessmentPage({super.key, required this.isPost});

  @override
  State<ImpactAssessmentPage> createState() => _ImpactAssessmentPageState();
}

class _ImpactAssessmentPageState extends State<ImpactAssessmentPage> {
  final _progress = FlagshipProgressService();
  int _index = 0;
  int? _selected;
  int _score = 0;

  List<_AssessmentQuestion> get _questions =>
      widget.isPost ? _postQuestions : _baselineQuestions;

  Future<void> _next() async {
    if (_selected == null) return;
    if (_questions[_index].correctIndex == _selected) _score++;
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }
    await _progress.saveAssessment(isPost: widget.isPost, score: _score);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    final question = _questions[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isPost
              ? (english ? 'Learning check' : 'Comprobación de aprendizaje')
              : (english ? 'Starting point' : 'Punto de partida'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_index + 1) / _questions.length,
                minHeight: 8,
                borderRadius: BorderRadius.circular(99),
              ),
              const SizedBox(height: 24),
              Card(
                color: AppTheme.primaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    question.prompt.resolve(Localizations.localeOf(context)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ...List.generate(
                question.options.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(62),
                      alignment: Alignment.centerLeft,
                      backgroundColor: _selected == index
                          ? AppTheme.accentGreen.withValues(alpha: 0.2)
                          : null,
                      side: BorderSide(
                        color: _selected == index
                            ? AppTheme.primaryDark
                            : const Color(0xFFD8DEE9),
                        width: _selected == index ? 2 : 1,
                      ),
                    ),
                    onPressed: () => setState(() => _selected = index),
                    child: Text(
                      question.options[index].resolve(
                        Localizations.localeOf(context),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                english
                    ? 'This anonymous check measures the learning experience, not you.'
                    : 'Esta comprobación anónima mide la experiencia, no te califica a ti.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selected == null ? null : _next,
                child: Text(english ? 'Continue' : 'Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _baselineQuestions = <_AssessmentQuestion>[
    _AssessmentQuestion(
      prompt: LocalizedText(
        es: 'Recibes una alerta urgente sin autor. ¿Qué haces primero?',
        en: 'You receive an urgent alert with no author. What do you do first?',
      ),
      options: [
        LocalizedText(
          es: 'La comparto por prevención',
          en: 'Share it just in case',
        ),
        LocalizedText(
          es: 'Pauso y busco la fuente original',
          en: 'Pause and find the original source',
        ),
        LocalizedText(
          es: 'Miro cuántos me gusta tiene',
          en: 'Check how many likes it has',
        ),
      ],
      correctIndex: 1,
    ),
    _AssessmentQuestion(
      prompt: LocalizedText(
        es: 'Una foto parece real. ¿Qué prueba mejor su autenticidad?',
        en: 'A photo looks real. What best supports its authenticity?',
      ),
      options: [
        LocalizedText(
          es: 'Que no tenga errores visibles',
          en: 'It has no visible glitches',
        ),
        LocalizedText(
          es: 'Que la compartan muchas personas',
          en: 'Many people share it',
        ),
        LocalizedText(
          es: 'Su procedencia y fuentes independientes',
          en: 'Its provenance and independent sources',
        ),
      ],
      correctIndex: 2,
    ),
    _AssessmentQuestion(
      prompt: LocalizedText(
        es: 'Un meme generaliza sobre un grupo. ¿Cuál es una acción responsable?',
        en: 'A meme stereotypes a group. What is a responsible action?',
      ),
      options: [
        LocalizedText(
          es: 'No amplificarlo y apoyar a quien afecta',
          en: 'Do not amplify it and support those affected',
        ),
        LocalizedText(
          es: 'Reenviarlo para preguntar si molesta',
          en: 'Forward it to ask if it is offensive',
        ),
        LocalizedText(es: 'Ignorarlo siempre', en: 'Always ignore it'),
      ],
      correctIndex: 0,
    ),
  ];

  static const _postQuestions = <_AssessmentQuestion>[
    _AssessmentQuestion(
      prompt: LocalizedText(
        es: 'Un audio asegura que habrá una emergencia y pide reenviarlo. No cita fuente. ¿Qué haces?',
        en: 'An audio claims there is an emergency and asks you to forward it. It cites no source. What do you do?',
      ),
      options: [
        LocalizedText(
          es: 'Reenviarlo a una sola persona',
          en: 'Forward it to only one person',
        ),
        LocalizedText(
          es: 'Buscar el aviso oficial y corroborar',
          en: 'Find the official notice and corroborate',
        ),
        LocalizedText(
          es: 'Creerlo si la voz suena adulta',
          en: 'Believe it if the voice sounds adult',
        ),
      ],
      correctIndex: 1,
    ),
    _AssessmentQuestion(
      prompt: LocalizedText(
        es: 'Una imagen podría haber sido creada con IA. ¿Qué pregunta ayuda más?',
        en: 'An image may be AI-generated. Which question helps most?',
      ),
      options: [
        LocalizedText(
          es: '¿Tiene manos perfectas?',
          en: 'Does it have perfect hands?',
        ),
        LocalizedText(
          es: '¿Me gusta lo que afirma?',
          en: 'Do I like what it claims?',
        ),
        LocalizedText(
          es: '¿Cuál es su origen y qué evidencia la respalda?',
          en: 'What is its origin and what evidence supports it?',
        ),
      ],
      correctIndex: 2,
    ),
    _AssessmentQuestion(
      prompt: LocalizedText(
        es: 'Quieres corregir contenido dañino. ¿Cómo evitas amplificarlo?',
        en: 'You want to correct harmful content. How do you avoid amplifying it?',
      ),
      options: [
        LocalizedText(
          es: 'Explicar la evidencia sin republicar el material',
          en: 'Explain the evidence without reposting the material',
        ),
        LocalizedText(
          es: 'Publicarlo otra vez con una advertencia',
          en: 'Post it again with a warning',
        ),
        LocalizedText(
          es: 'Atacar a quien lo compartió',
          en: 'Attack the person who shared it',
        ),
      ],
      correctIndex: 0,
    ),
  ];
}

class _AssessmentQuestion {
  final LocalizedText prompt;
  final List<LocalizedText> options;
  final int correctIndex;
  const _AssessmentQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}
