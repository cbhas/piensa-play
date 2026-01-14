import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../domain/entities/user_profile.dart';

class OnboardingRepositoryImpl {
  static const String _profileKey = 'user_profile';

  // Guardar perfil
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode({
        'name': profile.name,
        'age': profile.age,
        'avatarId': profile.avatarId,
      });
      await prefs.setString(_profileKey, profileJson);
      AppLogger.success('Perfil guardado: $profileJson');
    } catch (e) {
      AppLogger.error('Error guardando perfil: $e');
      rethrow;
    }
  }

  // Obtener perfil
  Future<UserProfile?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);

      AppLogger.log('Perfil recuperado: $profileJson');

      if (profileJson == null) return null;

      final Map<String, dynamic> data = jsonDecode(profileJson);
      return UserProfile(
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        avatarId: data['avatarId'] ?? 'cocodrilo',
      );
    } catch (e) {
      AppLogger.error('Error recuperando perfil: $e');
      return null;
    }
  }
}
