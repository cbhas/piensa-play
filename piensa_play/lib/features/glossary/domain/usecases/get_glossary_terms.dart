// lib/features/glossary/domain/usecases/get_glossary_terms.dart

import 'package:piensa_play/core/services/logger_service.dart';
import '../entities/glossary_term.dart';
import '../../data/repositories/glossary_repository_impl.dart';

class GetGlossaryTerms {
  final GlossaryRepositoryImpl _repository = GlossaryRepositoryImpl();

  /// Fetch all glossary terms (remote first, fallback to cache)
  Future<List<GlossaryTerm>> execute(String userId) async {
    AppLogger.log('GLOSSARY: Fetching terms for user $userId');
    return await _repository.getGlossaryTerms(userId);
  }

  /// Save glossary terms to cache and remote
  Future<void> save(String userId, List<GlossaryTerm> terms) async {
    AppLogger.log('GLOSSARY: Saving ${terms.length} terms');
    await _repository.saveGlossaryTerms(userId, terms);
  }

  /// Search terms by query
  List<GlossaryTerm> search(List<GlossaryTerm> terms, String query) {
    if (query.isEmpty) return terms;

    final lowerQuery = query.toLowerCase();
    return terms.where((term) {
      return term.term.toLowerCase().contains(lowerQuery) ||
          term.definition.toLowerCase().contains(lowerQuery) ||
          term.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter terms by category
  List<GlossaryTerm> filterByCategory(
    List<GlossaryTerm> terms,
    String category,
  ) {
    if (category.isEmpty || category == 'Todos') return terms;

    return terms.where((term) {
      return term.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  /// Get unique categories from terms
  List<String> getCategories(List<GlossaryTerm> terms) {
    final categories = terms.map((term) => term.category).toSet().toList();
    categories.sort();
    return ['Todos', ...categories];
  }
}
