import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mission_category.dart';

class MissionsRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMissionCategories(
    String userId,
    List<MissionCategory> categories,
  ) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('missions')
          .doc('categories');

      await docRef.set({
        'categories': categories
            .map(
              (cat) => {
                'id': cat.id,
                'title': cat.title,
                'description': cat.description,
                'iconName': cat.iconName,
                'colorHex': cat.colorHex,
                'missions': cat.missions
                    .map(
                      (m) => {
                        'id': m.id,
                        'title': m.title,
                        'description': m.description,
                        'isCompleted': m.isCompleted,
                        'iconName': m.iconName,
                      },
                    )
                    .toList(),
              },
            )
            .toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error guardando misiones en Firestore: $e');
      rethrow;
    }
  }
}
