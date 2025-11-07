import '../entities/dashboard_stats.dart';
import '../../data/repositories/home_repository_impl.dart';

class GetDashboardStats {
  final HomeRepositoryImpl _repository = HomeRepositoryImpl();

  Future<DashboardStats> execute(String userId) async {
    return await _repository.getDashboardStats(userId);
  }

  Future<void> save(String userId, DashboardStats stats) async {
    await _repository.saveDashboardStats(userId, stats);
  }
}
