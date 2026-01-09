// lib/features/learn/domain/entities/media_item.dart

enum MediaType { video, audio }

class MediaItem {
  final String id;
  final String title;
  final String description;
  final MediaType type;
  final String category;
  final String thumbnailUrl;
  final String? youtubeId;
  final String? audioUrl;
  final int durationSeconds;
  final int order;

  const MediaItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.thumbnailUrl,
    this.youtubeId,
    this.audioUrl,
    required this.durationSeconds,
    required this.order,
  });

  /// Get formatted duration string (e.g., "2:30")
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get YouTube thumbnail URL from video ID
  String get youtubeThumbnail {
    if (youtubeId != null) {
      return 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
    }
    return thumbnailUrl;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.name,
    'category': category,
    'thumbnailUrl': thumbnailUrl,
    'youtubeId': youtubeId,
    'audioUrl': audioUrl,
    'durationSeconds': durationSeconds,
    'order': order,
  };

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    type: json['type'] == 'audio' ? MediaType.audio : MediaType.video,
    category: json['category'] ?? 'Videos',
    thumbnailUrl: json['thumbnailUrl'] ?? '',
    youtubeId: json['youtubeId'],
    audioUrl: json['audioUrl'],
    durationSeconds: json['durationSeconds'] ?? 0,
    order: json['order'] ?? 0,
  );

  MediaItem copyWith({
    String? id,
    String? title,
    String? description,
    MediaType? type,
    String? category,
    String? thumbnailUrl,
    String? youtubeId,
    String? audioUrl,
    int? durationSeconds,
    int? order,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      youtubeId: youtubeId ?? this.youtubeId,
      audioUrl: audioUrl ?? this.audioUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      order: order ?? this.order,
    );
  }
}
