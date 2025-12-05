// lib/features/glossary/data/datasources/glossary_local_datasource.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/glossary_term.dart';

class GlossaryLocalDatasource {
  static const String _cacheKey = 'glossary_terms_cache';

  /// Save glossary terms to local cache
  Future<void> saveGlossaryTerms(List<GlossaryTerm> terms) async {
    print('🔵 GLOSSARY LOCAL: Saving ${terms.length} terms to cache');

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = terms.map((term) => term.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await prefs.setString(_cacheKey, jsonString);
      print('🟢 GLOSSARY LOCAL: Terms cached successfully');
    } catch (e) {
      print('❌ GLOSSARY LOCAL: Error caching terms: $e');
    }
  }

  /// Get glossary terms from local cache
  Future<List<GlossaryTerm>> getGlossaryTerms() async {
    print('🔵 GLOSSARY LOCAL: Reading from cache');

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);

      if (jsonString == null) {
        print('🟡 GLOSSARY LOCAL: No cache found');
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      final terms = jsonList
          .map((json) => GlossaryTerm.fromJson(json as Map<String, dynamic>))
          .toList();

      print('🟢 GLOSSARY LOCAL: Loaded ${terms.length} terms from cache');
      return terms;
    } catch (e) {
      print('❌ GLOSSARY LOCAL: Error reading cache: $e');
      return [];
    }
  }

  /// Clear glossary cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    print('🟢 GLOSSARY LOCAL: Cache cleared');
  }
}
