import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/media_item.dart';

class MediaItemCard extends StatefulWidget {
  final MediaItem item;
  final VoidCallback onTap;
  final int index;

  const MediaItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<MediaItemCard> createState() => _MediaItemCardState();
}

class _MediaItemCardState extends State<MediaItemCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  AnimationController? _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bright, fun colors for kids
    final colors = [
      const Color(0xFF42A5F5), // Bright Blue
      const Color(0xFF66BB6A), // Bright Green
      const Color(0xFFFFCA28), // Bright Yellow
      const Color(0xFFEC407A), // Bright Pink
      const Color(0xFFAB47BC), // Purple
      const Color(0xFFFF7043), // Orange
    ];
    final color = colors[widget.index % colors.length];

    return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.diagonal3Values(
              _isPressed ? 0.92 : 1.0,
              _isPressed ? 0.92 : 1.0,
              1.0,
            )..rotateZ(_isPressed ? -0.02 : 0.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circles in background
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Main content - fully centered
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Thumbnail with play icon
                          AnimatedBuilder(
                            animation:
                                _bounceController ??
                                AnimationController(
                                  vsync: this,
                                  duration: Duration.zero,
                                ),
                            builder: (context, child) {
                              final bounceValue =
                                  _bounceController?.value ?? 0.0;
                              return Transform.translate(
                                offset: Offset(0, -5 * bounceValue),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(
                                          0,
                                          5 + (5 * bounceValue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Thumbnail (if YouTube video)
                                      if (widget.item.youtubeId != null)
                                        ClipOval(
                                          child: Image.network(
                                            widget.item.youtubeThumbnail,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              widget.item.type ==
                                                      MediaType.video
                                                  ? Icons.play_circle_filled
                                                  : Icons.headphones,
                                              size: 36,
                                              color: color,
                                            ),
                                          ),
                                        ),
                                      // Play overlay
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          widget.item.type == MediaType.video
                                              ? Icons.play_arrow_rounded
                                              : Icons.headphones,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            widget.item.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Duration badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.item.type == MediaType.video
                                      ? Icons.videocam
                                      : Icons.mic,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.item.formattedDuration,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Shine effect overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: (widget.index * 100).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutBack)
        .then()
        .shimmer(
          duration: 2000.ms,
          delay: (widget.index * 300).ms,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }
}
