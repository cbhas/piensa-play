// lib/features/learn/data/repositories/learn_repository.dart

import 'package:piensa_play/core/services/logger_service.dart';
import '../datasources/learn_remote_datasource.dart';
import '../../domain/entities/media_item.dart';

class LearnRepository {
  final LearnRemoteDatasource _remoteDatasource = LearnRemoteDatasource();

  // Hardcoded fallback data for offline support
  static final List<MediaItem> _hardcodedItems = [
    const MediaItem(
      id: 'video_01',
      title: 'Alfabetización Mediática',
      description:
          'Aprende sobre los medios de comunicación y cómo interpretarlos correctamente.',
      type: MediaType.video,
      category: 'Videos',
      thumbnailUrl: '',
      youtubeId: 'ul7siGvqmB8',
      durationSeconds: 60,
      order: 1,
    ),
    // Add more items here as needed
  ];

  /// Get all media items - tries Firebase first, falls back to hardcoded
  Future<List<MediaItem>> getAllItems() async {
    try {
      // Try to fetch from Firebase
      final items = await _remoteDatasource.getLearnContent();
      if (items.isNotEmpty) {
        return items;
      }
      // If Firebase returns empty, use fallback
      AppLogger.warning('LEARN REPO: Firebase empty, using fallback data');
      return _hardcodedItems;
    } catch (e) {
      // On any error (network, etc.), use fallback
      AppLogger.warning('LEARN REPO: Firebase failed, using fallback data: $e');
      return _hardcodedItems;
    }
  }

  /// Get items by category
  List<MediaItem> filterByCategory(List<MediaItem> items, String category) {
    if (category == 'Todos') return items;
    if (category == 'Videos') {
      return items.where((item) => item.type == MediaType.video).toList();
    }
    if (category == 'Podcasts') {
      return items.where((item) => item.type == MediaType.audio).toList();
    }
    return items;
  }

  /// Search items by title or description
  List<MediaItem> search(List<MediaItem> items, String query) {
    if (query.isEmpty) return items;
    final lowerQuery = query.toLowerCase();
    return items.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
          item.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get available categories
  List<String> getCategories() {
    return ['Todos', 'Videos', 'Podcasts'];
  }
}
