import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/features/flagship/data/flagship_progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('stores anonymous decisions once and computes impact', () async {
    final service = FlagshipProgressService();
    await service.recordDecision(
      missionId: 'viral_post',
      challengeId: 'source',
      correctFirstTry: true,
    );
    await service.recordDecision(
      missionId: 'viral_post',
      challengeId: 'source',
      correctFirstTry: false,
    );
    await service.recordDecision(
      missionId: 'viral_post',
      challengeId: 'context',
      correctFirstTry: false,
    );
    await service.completeMission('viral_post');
    await service.saveAssessment(isPost: false, score: 1);
    await service.saveAssessment(isPost: true, score: 3);

    final impact = await service.impact();
    expect(impact.decisions, 2);
    expect(impact.correctFirstTry, 1);
    expect(impact.firstTryRate, 0.5);
    expect(impact.missionsCompleted, 1);
    expect(impact.baselineScore, 1);
    expect(impact.postScore, 3);
  });
}
