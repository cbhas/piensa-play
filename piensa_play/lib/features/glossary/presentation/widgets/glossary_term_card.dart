import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'glossary_mascots.dart';

class GlossaryTermCard extends StatefulWidget {
  final String term;
  final String icon;
  final VoidCallback onTap;
  final int index;

  const GlossaryTermCard({
    super.key,
    required this.term,
    required this.icon,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<GlossaryTermCard> createState() => _GlossaryTermCardState();
}

class _GlossaryTermCardState extends State<GlossaryTermCard>
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

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated icon with bounce
                        AnimatedBuilder(
                          animation:
                              _bounceController ??
                              AnimationController(
                                vsync: this,
                                duration: Duration.zero,
                              ),
                          builder: (context, child) {
                            final bounceValue = _bounceController?.value ?? 0.0;
                            return Transform.translate(
                              offset: Offset(0, -5 * bounceValue),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 10,
                                      offset: Offset(0, 5 + (5 * bounceValue)),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    widget.icon,
                                    style: const TextStyle(fontSize: 42),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Term name
                        Text(
                          widget.term,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sparkle dots
                        Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (i) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 1500.ms,
                              delay: (widget.index * 200).ms,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                      ],
                    ),
                  ),

                  // Two Mascot characters 🎭🎭
                  ...GlossaryMascots.getMascotsForCard(widget.index).map((
                    mascotConfig,
                  ) {
                    final mascotPath = mascotConfig['path'] as String;
                    final position =
                        mascotConfig['position'] as Map<String, dynamic>;

                    return Positioned(
                      top: position['top'],
                      bottom: position['bottom'],
                      left: position['left'],
                      right: position['right'],
                      child: AnimatedBuilder(
                        animation:
                            _bounceController ??
                            AnimationController(
                              vsync: this,
                              duration: Duration.zero,
                            ),
                        builder: (context, child) {
                          final bounceValue = _bounceController?.value ?? 0.0;
                          return Transform.rotate(
                            angle:
                                (position['rotation'] as double) +
                                (0.05 * bounceValue),
                            child: Transform.translate(
                              offset: Offset(2 * bounceValue, -3 * bounceValue),
                              child: Image.asset(
                                mascotPath,
                                width: 65,
                                height: 65,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback if image doesn't load
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),

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
