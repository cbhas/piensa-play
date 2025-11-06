class UserProfile {
  final String name;
  final int age;
  final String avatarId;

  const UserProfile({
    required this.name,
    required this.age,
    required this.avatarId,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? avatarId,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      avatarId: avatarId ?? this.avatarId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'avatarId': avatarId,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      age: json['age'] as int,
      avatarId: json['avatarId'] as String,
    );
  }
}