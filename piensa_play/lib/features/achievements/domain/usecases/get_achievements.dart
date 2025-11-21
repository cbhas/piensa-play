import '../entities/achievement.dart';
import '../../data/repositories/achievements_repository_impl.dart';

class GetAchievements {
  final AchievementsRepositoryImpl _repository = AchievementsRepositoryImpl();

  Future<Achievement> execute(String userId) async {
    return await _repository.getAchievements(userId);
  }

  Future<void> save(String userId, Achievement achievement) async {
    await _repository.saveAchievements(userId, achievement);
  }
}
