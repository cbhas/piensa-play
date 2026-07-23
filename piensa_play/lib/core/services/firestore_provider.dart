import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Acceso centralizado a la instancia configurada de [FirebaseFirestore].
///
/// Todos los servicios y datasources deben usar [FirestoreProvider.instance]
/// en lugar de llamar a `FirebaseFirestore.instance` directamente. Esto
/// mantiene la configuración de Firestore en un solo lugar y facilita
/// sustituir la dependencia en los tests.
class FirestoreProvider {
  FirestoreProvider._();

  /// Instancia única de Firestore usada en toda la app.
  static final FirebaseFirestore instance = FirebaseFirestore.instance;

  /// Aplica la configuración global de Firestore (caché y persistencia).
  /// Debe llamarse una sola vez, justo después de `Firebase.initializeApp`.
  static void configure() {
    if (kIsWeb) {
      instance.settings = const Settings(
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } else {
      instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    }
  }
}
