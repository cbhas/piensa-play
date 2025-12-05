// lib/features/glossary/data/datasources/glossary_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/glossary_term.dart';

class GlossaryRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all glossary terms from Firestore, ordered by 'order' field
  Future<List<GlossaryTerm>> getGlossaryTerms(String userId) async {
    print('🔵 GLOSSARY REMOTE: Fetching from Firestore...');

    try {
      final snapshot = await _firestore
          .collection('glossary')
          .orderBy('order')
          .get();

      final terms = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Use document ID as id
        return GlossaryTerm.fromJson(data);
      }).toList();

      print('🟢 GLOSSARY REMOTE: Fetched ${terms.length} terms');
      return terms;
    } catch (e) {
      print('❌ GLOSSARY REMOTE: Error fetching terms: $e');
      rethrow;
    }
  }

  /// Save glossary terms to Firestore (not typically needed for glossary)
  Future<void> saveGlossaryTerms(
    String userId,
    List<GlossaryTerm> terms,
  ) async {
    print('🔵 GLOSSARY REMOTE: Saving ${terms.length} terms to Firestore');

    try {
      final batch = _firestore.batch();

      for (final term in terms) {
        final docRef = _firestore.collection('glossary').doc(term.id);
        batch.set(docRef, term.toJson());
      }

      await batch.commit();
      print('🟢 GLOSSARY REMOTE: Terms saved successfully');
    } catch (e) {
      print('❌ GLOSSARY REMOTE: Error saving terms: $e');
      rethrow;
    }
  }
}
