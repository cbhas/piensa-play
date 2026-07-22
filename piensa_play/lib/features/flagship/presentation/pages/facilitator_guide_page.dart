import 'package:flutter/material.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/theme/app_theme.dart';

class FacilitatorGuidePage extends StatelessWidget {
  const FacilitatorGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    final sections = english ? _englishSections : _spanishSections;
    return Scaffold(
      appBar: AppBar(title: Text(context.strings.t('facilitator'))),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        itemCount: sections.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              color: AppTheme.primaryDark,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.groups_2_outlined,
                      color: AppTheme.accentGreen,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      english
                          ? 'A 30-minute classroom experience'
                          : 'Una experiencia de aula de 30 minutos',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      english
                          ? 'No account is required. Ask learners to discuss evidence before voting.'
                          : 'No requiere cuentas. Pide al grupo debatir la evidencia antes de votar.',
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          final section = sections[index - 1];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.$1,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ...section.$2.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.arrow_right_rounded,
                            color: AppTheme.primaryDark,
                          ),
                          const SizedBox(width: 6),
                          Expanded(child: Text(line)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static const _spanishSections = <(String, List<String>)>[
    (
      'Antes de jugar',
      [
        'Presenta PIENSA sin explicar todavía las respuestas.',
        'Usa tres escenarios nuevos como evaluación inicial.',
        'Asegura que nadie comparta nombres o experiencias personales sensibles.',
      ],
    ),
    (
      'Durante las misiones',
      [
        'Activa Modo aula y recoge una votación antes de revelar la explicación.',
        'Pide que cada equipo mencione una evidencia, no solamente su opinión.',
        'Evita ridiculizar respuestas: una decisión incorrecta es una oportunidad de practicar.',
      ],
    ),
    (
      'Después de jugar',
      [
        'Repite la evaluación con casos distintos para medir transferencia.',
        'Pregunta qué paso de PIENSA usarán la próxima vez que reciban algo urgente.',
        'Invita al grupo a crear un mensaje responsable sin volver a publicar contenido dañino.',
      ],
    ),
    (
      'Protección e inclusión',
      [
        'Obtén consentimiento adulto para cualquier piloto con menores.',
        'Registra resultados agregados y anónimos; no recolectes conversaciones privadas.',
        'Permite lectura en voz alta, más tiempo y participación sin dispositivo individual.',
      ],
    ),
  ];

  static const _englishSections = <(String, List<String>)>[
    (
      'Before playing',
      [
        'Introduce PIENSA without revealing the answers.',
        'Use three unseen scenarios as a short pre-assessment.',
        'Make sure nobody shares names or sensitive personal experiences.',
      ],
    ),
    (
      'During missions',
      [
        'Enable Classroom Mode and collect a vote before revealing feedback.',
        'Ask every group to name one piece of evidence, not only an opinion.',
        'Never ridicule answers: a poor decision is an opportunity to practice.',
      ],
    ),
    (
      'After playing',
      [
        'Repeat the assessment with different cases to measure transfer.',
        'Ask which PIENSA step learners will use with the next urgent message.',
        'Create a responsible response without reposting harmful material.',
      ],
    ),
    (
      'Safeguarding and inclusion',
      [
        'Obtain adult consent for any pilot involving minors.',
        'Record anonymous aggregate outcomes, never private conversations.',
        'Offer read-aloud support, extra time and participation without individual devices.',
      ],
    ),
  ];
}
