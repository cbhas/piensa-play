// lib/features/glossary/data/datasources/glossary_local_datasource.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/glossary_term.dart';

class GlossaryLocalDatasource {
  static const String _cacheKey = 'glossary_terms_cache';

  /// Save glossary terms to local cache
  Future<void> saveGlossaryTerms(List<GlossaryTerm> terms) async {
    AppLogger.log('GLOSSARY LOCAL: Saving ${terms.length} terms to cache');

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = terms.map((term) => term.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await prefs.setString(_cacheKey, jsonString);
      AppLogger.success('GLOSSARY LOCAL: Terms cached successfully');
    } catch (e) {
      AppLogger.error('GLOSSARY LOCAL: Error caching terms: $e');
    }
  }

  /// Get glossary terms from local cache
  Future<List<GlossaryTerm>> getGlossaryTerms() async {
    AppLogger.log('GLOSSARY LOCAL: Reading from cache');

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);

      if (jsonString == null) {
        AppLogger.log('GLOSSARY LOCAL: No cache found');
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      final terms = jsonList
          .map((json) => GlossaryTerm.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.success(
        'GLOSSARY LOCAL: Loaded ${terms.length} terms from cache',
      );
      return terms;
    } catch (e) {
      AppLogger.error('GLOSSARY LOCAL: Error reading cache: $e');
      return [];
    }
  }

  /// Clear glossary cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    AppLogger.success('GLOSSARY LOCAL: Cache cleared');
  }
}
