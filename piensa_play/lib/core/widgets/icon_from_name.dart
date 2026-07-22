import 'package:flutter/material.dart';

/// Maps the icon-name strings used by quiz content (`QuizElement.icon`,
/// badge/glossary entries, etc.) to a real [IconData] so they render as
/// icons instead of literal text.
IconData iconFromName(String name) {
  switch (name) {
    case 'alarm':
      return Icons.alarm_rounded;
    case 'person':
      return Icons.person_rounded;
    case 'link':
      return Icons.link_rounded;
    case 'attach_money':
      return Icons.attach_money_rounded;
    case 'security':
      return Icons.security_rounded;
    case 'text_fields':
      return Icons.text_fields_rounded;
    case 'repeat':
      return Icons.repeat_rounded;
    case 'block':
      return Icons.block_rounded;
    case 'check_circle':
      return Icons.check_circle_rounded;
    case 'cancel':
      return Icons.cancel_rounded;
    case 'image':
      return Icons.image_rounded;
    case 'trending_up':
      return Icons.trending_up_rounded;
    case 'search':
      return Icons.search_rounded;
    case 'lock':
      return Icons.lock_rounded;
    case 'shield':
      return Icons.shield_rounded;
    case 'flag':
      return Icons.flag_rounded;
    case 'explore':
      return Icons.explore_rounded;
    case 'school':
      return Icons.school_rounded;
    case 'quiz':
      return Icons.quiz_rounded;
    default:
      return Icons.emoji_events_rounded;
  }
}
