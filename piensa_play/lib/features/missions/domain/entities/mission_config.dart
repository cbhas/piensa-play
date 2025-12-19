import 'package:flutter/material.dart';

/// Configuration for a single mission node on the map
class MissionConfig {
  final String id;
  final String title;
  final String description;
  final Offset position; // Position on the map (0.0-1.0 relative)
  final Widget Function(BuildContext) pageBuilder;
  final bool isCompleted;
  final bool isLocked;

  const MissionConfig({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    required this.pageBuilder,
    this.isCompleted = false,
    this.isLocked = false,
  });

  MissionConfig copyWith({
    String? id,
    String? title,
    String? description,
    Offset? position,
    Widget Function(BuildContext)? pageBuilder,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return MissionConfig(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      position: position ?? this.position,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

/// Configuration for a mission category map
class MapCategoryConfig {
  final String categoryId;
  final String categoryTitle;
  final Color categoryColor;
  final Color bannerColor;
  final Color nodeColor;
  final String backgroundImage;
  final bool useSequentialUnlock;

  const MapCategoryConfig({
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryColor,
    required this.bannerColor,
    required this.nodeColor,
    required this.backgroundImage,
    this.useSequentialUnlock =
        true, // Por defecto, todas usan desbloqueo secuencial
  });
}
