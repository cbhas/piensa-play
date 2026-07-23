import 'package:flutter_test/flutter_test.dart';
import 'package:piensa_play/features/flagship/data/flagship_content.dart';
import 'package:piensa_play/features/flagship/domain/flagship_mission.dart';

void main() {
  test('flagship is a complete three-mission bilingual vertical slice', () {
    expect(FlagshipContent.missions, hasLength(3));
    expect(
      FlagshipContent.missions.map((mission) => mission.id).toSet(),
      hasLength(3),
    );

    final coveredSkills = <PiensaSkill>{};
    for (final mission in FlagshipContent.missions) {
      expect(mission.challenges, hasLength(3));
      coveredSkills.addAll(mission.skills);
      for (final challenge in mission.challenges) {
        expect(challenge.context.es, isNotEmpty);
        expect(challenge.context.en, isNotEmpty);
        expect(challenge.prompt.es, isNotEmpty);
        expect(challenge.prompt.en, isNotEmpty);
        expect(
          challenge.choices.where((choice) => choice.isBestChoice),
          hasLength(1),
        );
        for (final choice in challenge.choices) {
          expect(choice.text.es, isNotEmpty);
          expect(choice.text.en, isNotEmpty);
          expect(choice.feedback.es, isNotEmpty);
          expect(choice.feedback.en, isNotEmpty);
        }
      }
    }

    expect(coveredSkills, PiensaSkill.values.toSet());
  });
}
