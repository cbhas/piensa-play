import 'package:flutter/material.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/flagship_progress_service.dart';
import '../../domain/flagship_mission.dart';
import '../piensa_ui.dart';
import 'flagship_result_page.dart';

class FlagshipMissionPage extends StatefulWidget {
  final FlagshipMission mission;
  final int missionIndex;
  final bool classroomMode;

  const FlagshipMissionPage({
    super.key,
    required this.mission,
    required this.missionIndex,
    this.classroomMode = false,
  });

  @override
  State<FlagshipMissionPage> createState() => _FlagshipMissionPageState();
}

class _FlagshipMissionPageState extends State<FlagshipMissionPage> {
  final _progress = FlagshipProgressService();
  int _challengeIndex = 0;
  int? _selectedChoice;
  bool _revealed = false;
  int _correctFirstTry = 0;

  FlagshipChallenge get _challenge =>
      widget.mission.challenges[_challengeIndex];

  Locale get _locale => Localizations.localeOf(context);

  Future<void> _check() async {
    final selected = _selectedChoice;
    if (selected == null || _revealed) return;
    final correct = _challenge.choices[selected].isBestChoice;
    if (correct) _correctFirstTry++;
    await _progress.recordDecision(
      missionId: widget.mission.id,
      challengeId: _challenge.id,
      correctFirstTry: correct,
    );
    if (!mounted) return;
    setState(() => _revealed = true);
  }

  Future<void> _continue() async {
    if (_challengeIndex < widget.mission.challenges.length - 1) {
      setState(() {
        _challengeIndex++;
        _selectedChoice = null;
        _revealed = false;
      });
      return;
    }

    await _progress.completeMission(widget.mission.id);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => FlagshipResultPage(
          mission: widget.mission,
          missionIndex: widget.missionIndex,
          correctFirstTry: _correctFirstTry,
          classroomMode: widget.classroomMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final progress = (_challengeIndex + 1) / widget.mission.challenges.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t(widget.mission.titleKey)),
        actions: [
          if (widget.classroomMode)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.groups_2_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: widget.mission.color.withValues(
                          alpha: 0.2,
                        ),
                        valueColor: AlwaysStoppedAnimation(
                          widget.mission.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_challengeIndex + 1}/${widget.mission.challenges.length}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PiensaSkillChip(
                        skill: _challenge.skill,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ScenarioCard(
                      mission: widget.mission,
                      challenge: _challenge,
                      locale: _locale,
                    ),
                    const SizedBox(height: 16),
                    _CluesCard(challenge: _challenge, locale: _locale),
                    const SizedBox(height: 22),
                    Text(
                      _challenge.prompt.resolve(_locale),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.classroomMode
                          ? strings.t('classroomBody')
                          : strings.t('chooseAction'),
                    ),
                    const SizedBox(height: 14),
                    if (_revealed) ...[
                      _FeedbackCard(
                        challenge: _challenge,
                        choice: _challenge.choices[_selectedChoice!],
                        locale: _locale,
                      ),
                      const SizedBox(height: 14),
                    ],
                    ...List.generate(
                      _challenge.choices.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ChoiceCard(
                          index: index,
                          choice: _challenge.choices[index],
                          locale: _locale,
                          selected: _selectedChoice == index,
                          revealed: _revealed,
                          onTap: _revealed
                              ? null
                              : () => setState(() => _selectedChoice = index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _revealed
                      ? _continue
                      : (_selectedChoice == null ? null : _check),
                  icon: Icon(
                    _revealed
                        ? Icons.arrow_forward_rounded
                        : Icons.fact_check_outlined,
                  ),
                  label: Text(
                    strings.t(_revealed ? 'continue' : 'checkAnswer'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final FlagshipMission mission;
  final FlagshipChallenge challenge;
  final Locale locale;

  const _ScenarioCard({
    required this.mission,
    required this.challenge,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: mission.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(mission.icon, color: AppTheme.primaryDark),
                ),
                const SizedBox(width: 12),
                Text(
                  context.strings.t('scenario').toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              challenge.context.resolve(locale),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CluesCard extends StatelessWidget {
  final FlagshipChallenge challenge;
  final Locale locale;
  const _CluesCard({required this.challenge, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.accentYellow.withValues(alpha: 0.22),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.saved_search_rounded),
                const SizedBox(width: 8),
                Text(
                  context.strings.t('clues'),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...challenge.clues.map(
              (clue) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '•  ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Text(clue.resolve(locale))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final int index;
  final FlagshipChoice choice;
  final Locale locale;
  final bool selected;
  final bool revealed;
  final VoidCallback? onTap;

  const _ChoiceCard({
    required this.index,
    required this.choice,
    required this.locale,
    required this.selected,
    required this.revealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color border = const Color(0xFFD8DEE9);
    Color fill = Theme.of(context).colorScheme.surface;
    if (selected) {
      border = AppTheme.primaryDark;
      fill = AppTheme.accentBlue.withValues(alpha: 0.13);
    }
    if (revealed && selected) {
      border = choice.isBestChoice ? Colors.green.shade600 : AppTheme.accentRed;
      fill = border.withValues(alpha: 0.09);
    }

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border, width: selected ? 2 : 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected ? border : border.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    choice.text.resolve(locale),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (revealed && selected)
                  Icon(
                    choice.isBestChoice ? Icons.check_circle : Icons.info,
                    color: border,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final FlagshipChallenge challenge;
  final FlagshipChoice choice;
  final Locale locale;

  const _FeedbackCard({
    required this.challenge,
    required this.choice,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final color = choice.isBestChoice
        ? Colors.green.shade700
        : AppTheme.accentRed;
    return Card(
      color: color.withValues(alpha: 0.09),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  choice.isBestChoice ? Icons.check_circle : Icons.lightbulb,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  context.strings.t(
                    choice.isBestChoice ? 'correct' : 'tryAgain',
                  ),
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(choice.feedback.resolve(locale)),
            const SizedBox(height: 10),
            Text(
              challenge.takeaway.resolve(locale),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
