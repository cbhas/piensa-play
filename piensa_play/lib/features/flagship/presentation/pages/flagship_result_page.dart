import 'package:flutter/material.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/flagship_content.dart';
import '../../domain/flagship_mission.dart';
import '../piensa_ui.dart';
import 'flagship_mission_page.dart';

class FlagshipResultPage extends StatelessWidget {
  final FlagshipMission mission;
  final int missionIndex;
  final int correctFirstTry;
  final bool classroomMode;

  const FlagshipResultPage({
    super.key,
    required this.mission,
    required this.missionIndex,
    required this.correctFirstTry,
    required this.classroomMode,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final hasNext = missionIndex < FlagshipContent.missions.length - 1;
    final percentage = correctFirstTry / mission.challenges.length;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: mission.color,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.defaultShadow,
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: AppTheme.primaryDark,
                  size: 44,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                hasNext ? strings.t('resultTitle') : strings.t('demoComplete'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                hasNext ? strings.t('resultBody') : strings.t('demoMessage'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _ResultMetric(
                              value: '${(percentage * 100).round()}%',
                              label: strings.t('evidence'),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 54,
                            color: Colors.black12,
                          ),
                          Expanded(
                            child: _ResultMetric(
                              value: '+${mission.challenges.length * 10}',
                              label: strings.t('trust'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                color: AppTheme.accentGreen.withValues(alpha: 0.18),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.t('mastered'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: mission.skills
                            .map(
                              (skill) => PiensaSkillChip(
                                skill: skill,
                                color: AppTheme.primaryDark,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              if (hasNext)
                ElevatedButton.icon(
                  onPressed: () {
                    final next = FlagshipContent.missions[missionIndex + 1];
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => FlagshipMissionPage(
                          mission: next,
                          missionIndex: missionIndex + 1,
                          classroomMode: classroomMode,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(strings.t('nextMission')),
                ),
              if (hasNext) const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.location_city_outlined),
                label: Text(strings.t('backToCity')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  final String value;
  final String label;
  const _ResultMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: AppTheme.primaryDark),
        ),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
