import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Centralized animation system for PiensaPlay
/// Provides consistent, reusable animation patterns across the app
class AppAnimations {
  // Standard durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Standard curves
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve easeOutBack = Curves.easeOutBack;

  // Stagger delays
  static const Duration staggerShort = Duration(milliseconds: 50);
  static const Duration staggerMedium = Duration(milliseconds: 80);
  static const Duration staggerLong = Duration(milliseconds: 120);
}

/// Extension methods for common animation patterns
extension AnimateExtensions on Widget {
  /// Fade in with subtle slide from bottom
  /// Perfect for card entries and page elements
  Widget fadeInSlide({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }

  /// Staggered entry animation for list items
  /// Use with index to create cascade effect
  Widget staggeredEntry({
    required int index,
    Duration staggerDelay = const Duration(milliseconds: 80),
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: staggerDelay * index)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: Curves.easeOutBack,
        );
  }

  /// Gentle scale entrance
  /// Good for icons and small elements
  Widget scaleIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: Curves.easeOutBack,
        );
  }

  /// Tap scale feedback
  /// Provides tactile feedback on button press
  Widget tapScale({required VoidCallback? onTap, double scale = 0.95}) {
    return GestureDetector(
      onTap: onTap,
      child: animate(onPlay: (controller) => controller.forward())
          .scaleXY(
            begin: 1.0,
            end: scale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          )
          .then()
          .scaleXY(
            begin: scale,
            end: 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          ),
    );
  }

  /// Shimmer effect for highlights
  /// Subtle attention grabber
  Widget shimmerEffect({
    Duration delay = const Duration(milliseconds: 1000),
    Duration duration = const Duration(milliseconds: 1500),
    Color? color,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).shimmer(
      delay: delay,
      duration: duration,
      color: color ?? Colors.white.withValues(alpha: 0.2),
    );
  }

  /// Slide from left entrance
  /// Good for headers and banners
  Widget slideFromLeft({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration)
        .slideX(
          begin: -0.2,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }

  /// Slide from top entrance
  /// Good for headers
  Widget slideFromTop({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration)
        .slideY(
          begin: -0.2,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
