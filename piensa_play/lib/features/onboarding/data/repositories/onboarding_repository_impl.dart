import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/core/services/user_id_provider.dart';
import '../../domain/entities/user_profile.dart';

class OnboardingRepositoryImpl {
  static const String _profileKey = 'user_profile';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => UserIdProvider.currentUserId;

  // Guardar perfil en SharedPreferences Y Firebase
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      // 1. Guardar en SharedPreferences (para acceso offline rápido)
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode({
        'name': profile.name,
        'age': profile.age,
        'avatarId': profile.avatarId,
        'studentCode': profile.studentCode,
      });
      await prefs.setString(_profileKey, profileJson);
      AppLogger.success('Perfil guardado en SharedPreferences: $profileJson');

      // 2. Guardar en Firebase (para persistencia y recuperación)
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('profile')
          .doc('data')
          .set({
            'name': profile.name,
            'age': profile.age,
            'avatarId': profile.avatarId,
            'studentCode': profile.studentCode,
            'updatedAt': FieldValue.serverTimestamp(),
          });
      AppLogger.success('Perfil guardado en Firebase');
    } catch (e) {
      AppLogger.error('Error guardando perfil: $e');
      rethrow;
    }
  }

  // Obtener perfil: primero SharedPreferences, luego Firebase
  Future<UserProfile?> getUserProfile() async {
    try {
      // 1. Intentar desde SharedPreferences primero (más rápido)
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);

      if (profileJson != null) {
        AppLogger.log('Perfil recuperado de SharedPreferences');
        final Map<String, dynamic> data = jsonDecode(profileJson);
        return UserProfile(
          name: data['name'] ?? '',
          age: data['age'] ?? 0,
          avatarId: data['avatarId'] ?? 'cocodrilo',
          studentCode: data['studentCode'] ?? UserProfile.generateStudentCode(),
        );
      }

      // 2. Si no hay en SharedPreferences, buscar en Firebase
      AppLogger.log('Buscando perfil en Firebase...');
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('profile')
          .doc('data')
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        // Si el usuario no tiene studentCode, generar uno y guardarlo
        String studentCode = data['studentCode'] ?? '';
        if (studentCode.isEmpty) {
          studentCode = UserProfile.generateStudentCode();
          // Guardar el código generado en Firebase
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('profile')
              .doc('data')
              .update({'studentCode': studentCode});
          AppLogger.log(
            'Código de estudiante generado para usuario existente: $studentCode',
          );
        }

        final profile = UserProfile(
          name: data['name'] ?? '',
          age: data['age'] ?? 0,
          avatarId: data['avatarId'] ?? 'cocodrilo',
          studentCode: studentCode,
        );

        // Guardar en SharedPreferences para próximas consultas
        final cacheJson = jsonEncode({
          'name': profile.name,
          'age': profile.age,
          'avatarId': profile.avatarId,
          'studentCode': profile.studentCode,
        });
        await prefs.setString(_profileKey, cacheJson);
        AppLogger.success('Perfil recuperado de Firebase y cacheado');

        return profile;
      }

      AppLogger.log('No se encontró perfil');
      return null;
    } catch (e) {
      AppLogger.error('Error recuperando perfil: $e');
      return null;
    }
  }

  // Verificar si existe perfil (para splash screen)
  Future<bool> hasProfile() async {
    final profile = await getUserProfile();
    return profile != null && profile.name.isNotEmpty;
  }
}
