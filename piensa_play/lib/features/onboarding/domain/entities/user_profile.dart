import 'dart:math';

class UserProfile {
  final String name;
  final int age;
  final String avatarId;
  final String studentCode; // Código único de estudiante, generado una vez

  const UserProfile({
    required this.name,
    required this.age,
    required this.avatarId,
    required this.studentCode,
  });

  /// Genera un código de estudiante único (PP + 6 caracteres alfanuméricos)
  /// Formato: PP-XXXXXX (ejemplo: PP-A1B2C3)
  static String generateStudentCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    final code = List.generate(
      6,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    return 'PP-$code';
  }

  UserProfile copyWith({
    String? name,
    int? age,
    String? avatarId,
    String? studentCode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      avatarId: avatarId ?? this.avatarId,
      studentCode: studentCode ?? this.studentCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'avatarId': avatarId,
      'studentCode': studentCode,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      avatarId: json['avatarId'] as String? ?? 'cocodrilo',
      // Si no tiene código, genera uno nuevo (para usuarios existentes)
      studentCode: json['studentCode'] as String? ?? generateStudentCode(),
    );
  }
}
