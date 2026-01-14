// lib/features/glossary/data/repositories/glossary_repository_impl.dart

import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/glossary_term.dart';
import '../datasources/glossary_local_datasource.dart';
import '../datasources/glossary_remote_datasource.dart';

class GlossaryRepositoryImpl {
  final GlossaryLocalDatasource _localDatasource = GlossaryLocalDatasource();
  final GlossaryRemoteDatasource _remoteDatasource = GlossaryRemoteDatasource();

  /// Get glossary terms (remote first, fallback to cache)
  Future<List<GlossaryTerm>> getGlossaryTerms(String userId) async {
    AppLogger.log('GLOSSARY REPO: Fetching terms');

    try {
      // Try remote first
      final remoteTerms = await _remoteDatasource.getGlossaryTerms(userId);

      if (remoteTerms.isNotEmpty) {
        // Cache the remote data
        await _localDatasource.saveGlossaryTerms(remoteTerms);
        AppLogger.success(
          'GLOSSARY REPO: Returned ${remoteTerms.length} terms from remote',
        );
        return remoteTerms;
      }
    } catch (e) {
      AppLogger.warning('GLOSSARY REPO: Remote fetch failed, using cache: $e');
    }

    // Fallback to cache
    final cachedTerms = await _localDatasource.getGlossaryTerms();
    AppLogger.success(
      'GLOSSARY REPO: Returned ${cachedTerms.length} terms from cache',
    );
    return cachedTerms;
  }

  /// Save glossary terms (local immediately, remote fire-and-forget)
  Future<void> saveGlossaryTerms(
    String userId,
    List<GlossaryTerm> terms,
  ) async {
    AppLogger.log('GLOSSARY REPO: Saving ${terms.length} terms');

    // Save to local cache immediately
    await _localDatasource.saveGlossaryTerms(terms);

    // Try to sync to remote (fire-and-forget)
    try {
      await _remoteDatasource.saveGlossaryTerms(userId, terms);
      AppLogger.success('GLOSSARY REPO: Synced to remote');
    } catch (e) {
      AppLogger.warning(
        'GLOSSARY REPO: Remote sync failed (saved locally): $e',
      );
    }
  }
}
