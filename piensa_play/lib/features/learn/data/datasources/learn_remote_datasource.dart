// lib/features/learn/data/datasources/learn_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/media_item.dart';

class LearnRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all learn content from Firestore, ordered by 'order' field
  Future<List<MediaItem>> getLearnContent() async {
    AppLogger.log('LEARN REMOTE: Fetching from Firestore...');

    try {
      final snapshot = await _firestore
          .collection('learn_content')
          .orderBy('order')
          .get();

      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Use document ID as id
        return MediaItem.fromJson(data);
      }).toList();

      AppLogger.success(
        'LEARN REMOTE: Fetched ${items.length} items from Firebase',
      );
      return items;
    } catch (e) {
      AppLogger.error('LEARN REMOTE: Error fetching content: $e');
      rethrow;
    }
  }
}
