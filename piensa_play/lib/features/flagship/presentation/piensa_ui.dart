import 'package:flutter/material.dart';

import '../../../core/localization/app_locale.dart';
import '../domain/flagship_mission.dart';

String piensaSkillLabel(BuildContext context, PiensaSkill skill) {
  final strings = context.strings;
  return switch (skill) {
    PiensaSkill.pause => strings.t('stepPause'),
    PiensaSkill.identify => strings.t('stepIdentify'),
    PiensaSkill.examine => strings.t('stepExamine'),
    PiensaSkill.notice => strings.t('stepNotice'),
    PiensaSkill.seek => strings.t('stepSeek'),
    PiensaSkill.act => strings.t('stepAct'),
  };
}

IconData piensaSkillIcon(PiensaSkill skill) => switch (skill) {
  PiensaSkill.pause => Icons.pause_circle_outline_rounded,
  PiensaSkill.identify => Icons.person_search_rounded,
  PiensaSkill.examine => Icons.fact_check_outlined,
  PiensaSkill.notice => Icons.psychology_alt_outlined,
  PiensaSkill.seek => Icons.manage_search_rounded,
  PiensaSkill.act => Icons.volunteer_activism_outlined,
};

class PiensaSkillChip extends StatelessWidget {
  final PiensaSkill skill;
  final Color color;
  final bool compact;

  const PiensaSkillChip({
    super.key,
    required this.skill,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: piensaSkillLabel(context, skill),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(piensaSkillIcon(skill), color: color, size: compact ? 16 : 18),
            const SizedBox(width: 6),
            Text(
              piensaSkillLabel(context, skill),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: compact ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
