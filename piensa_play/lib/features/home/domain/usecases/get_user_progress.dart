import '../entities/user_progress.dart';
import '../../data/repositories/home_repository_impl.dart';

class GetUserProgress {
  final HomeRepositoryImpl _repository = HomeRepositoryImpl();

  Future<UserProgress> execute(String userId) async {
    return await _repository.getUserProgress(userId);
  }

  Future<void> save(String userId, UserProgress progress) async {
    await _repository.saveUserProgress(userId, progress);
  }
}
