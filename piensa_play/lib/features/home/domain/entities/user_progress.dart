class UserProgress {
  final double generalProgress;
  final Map<String, double> monthlyProgress;

  const UserProgress({
    required this.generalProgress,
    required this.monthlyProgress,
  });

  Map<String, dynamic> toJson() => {
    'generalProgress': generalProgress,
    'monthlyProgress': monthlyProgress,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    generalProgress: (json['generalProgress'] as num?)?.toDouble() ?? 0.0,
    monthlyProgress: Map<String, double>.from(
      (json['monthlyProgress'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
          ) ??
          {},
    ),
  );
}
