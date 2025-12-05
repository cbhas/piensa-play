import '../entities/badge.dart';
import '../../data/repositories/achievements_repository_impl.dart';

class GetBadges {
  final AchievementsRepositoryImpl _repository = AchievementsRepositoryImpl();

  Future<List<Badge>> execute(String userId) async {
    return await _repository.getBadges(userId);
  }

  Future<void> save(String userId, List<Badge> badges) async {
    await _repository.saveBadges(userId, badges);
  }
}
