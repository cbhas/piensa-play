import 'package:flutter/material.dart';

class LocalizedText {
  final String es;
  final String en;
  const LocalizedText({required this.es, required this.en});

  String resolve(Locale locale) => locale.languageCode == 'en' ? en : es;
}

enum PiensaSkill { pause, identify, examine, notice, seek, act }

class FlagshipChoice {
  final LocalizedText text;
  final bool isBestChoice;
  final LocalizedText feedback;

  const FlagshipChoice({
    required this.text,
    required this.isBestChoice,
    required this.feedback,
  });
}

class FlagshipChallenge {
  final String id;
  final PiensaSkill skill;
  final LocalizedText context;
  final LocalizedText prompt;
  final List<LocalizedText> clues;
  final List<FlagshipChoice> choices;
  final LocalizedText takeaway;

  const FlagshipChallenge({
    required this.id,
    required this.skill,
    required this.context,
    required this.prompt,
    required this.clues,
    required this.choices,
    required this.takeaway,
  });
}

class FlagshipMission {
  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final List<PiensaSkill> skills;
  final List<FlagshipChallenge> challenges;

  const FlagshipMission({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    required this.skills,
    required this.challenges,
  });
}
