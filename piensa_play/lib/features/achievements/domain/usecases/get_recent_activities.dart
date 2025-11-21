import '../entities/recent_activity.dart';
import '../../data/repositories/achievements_repository_impl.dart';

class GetRecentActivities {
  final AchievementsRepositoryImpl _repository = AchievementsRepositoryImpl();

  Future<List<RecentActivity>> execute(String userId) async {
    return await _repository.getRecentActivities(userId);
  }

  Future<void> save(String userId, List<RecentActivity> activities) async {
    await _repository.saveRecentActivities(userId, activities);
  }
}
