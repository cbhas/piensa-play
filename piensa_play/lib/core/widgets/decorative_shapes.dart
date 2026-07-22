import 'package:flutter/material.dart';

/// A small scattering of soft, blurred color circles meant to sit behind
/// content (inside a [Stack]) to add playful energy to a screen without
/// competing with the foreground for attention. Purely decorative —
/// wrap in `IgnorePointer` behaviour is implicit since it paints only.
class FloatingBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double alpha;

  const FloatingBlob({
    super.key,
    required this.size,
    required this.color,
    this.alpha = 0.16,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// A tiny sparkle/star glyph used as a lightweight decorative accent
/// (e.g. next to headlines or scattered around a hero illustration).
class Sparkle extends StatelessWidget {
  final double size;
  final Color color;

  const Sparkle({super.key, this.size = 18, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Icon(Icons.auto_awesome_rounded, size: size, color: color),
    );
  }
}
