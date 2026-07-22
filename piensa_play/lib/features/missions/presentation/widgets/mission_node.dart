import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

enum MissionNodeType { locked, unlocked, inProgress, completed, chest }

class MissionNodeWidget extends StatelessWidget {
  final MissionNodeType type;
  final bool isSelected;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onPlay; // Callback para navegar directamente
  final int index;
  final Color? nodeColor;

  const MissionNodeWidget({
    super.key,
    required this.type,
    this.isSelected = false,
    this.progress = 0.0,
    this.onTap,
    this.onPlay,
    this.index = 0,
    this.nodeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (type == MissionNodeType.chest) {
      return _buildChestNode();
    }

    // Usar Stack para separar el botón JUGAR del GestureDetector del nodo
    return SizedBox(
          width: 80,
          height: 120, // Más alto para incluir el botón JUGAR
          child: Stack(
            alignment: Alignment.bottomCenter, // Nodo en la parte inferior
            clipBehavior: Clip.none,
            children: [
              // Nodo principal con su propio GestureDetector
              GestureDetector(
                onTap: type != MissionNodeType.locked
                    ? () {
                        Feedback.forTap(context);
                        onTap?.call();
                      }
                    : null,
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Yellow ring for selected node
                      if (isSelected && type == MissionNodeType.unlocked)
                        CustomPaint(
                              size: const Size(75, 75),
                              painter: YellowRingPainter(),
                            )
                            .animate()
                            .scale(
                              begin: const Offset(0.7, 0.7),
                              end: const Offset(1.0, 1.0),
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(duration: 200.ms),
                      // Bottom shadow
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Main node
                      Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _getNodeGradient(),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.9),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: _getNodeColor().withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.06),
                                      ],
                                      stops: const [0.65, 1.0],
                                    ),
                                  ),
                                ),
                                Center(child: _getNodeIcon()),
                              ],
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .shimmer(
                            delay: (1500 + index * 200).ms,
                            duration: 2500.ms,
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                    ],
                  ),
                ),
              ),

              // "JUGAR" button - FUERA del GestureDetector del nodo
              if (isSelected && type == MissionNodeType.unlocked)
                Positioned(
                  top: 0, // Ahora está dentro del SizedBox
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Feedback.forTap(context);
                      if (onPlay != null) {
                        onPlay!();
                      } else if (onTap != null) {
                        onTap!();
                      }
                    },
                    child:
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'JUGAR',
                                style: TextStyle(
                                  color: Color(0xFF7FA891),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 250.ms, curve: Curves.easeOut)
                            .slideY(
                              begin: 0.5,
                              end: 0,
                              duration: 350.ms,
                              curve: Curves.easeOutBack,
                            )
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                              duration: 350.ms,
                              curve: Curves.easeOutBack,
                            ),
                  ),
                ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: (100 + index * 80).ms, duration: 400.ms)
        .scale(
          delay: (100 + index * 80).ms,
          duration: 500.ms,
          begin: const Offset(0.5, 0.5),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildChestNode() {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minWidth: 90, minHeight: 90),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 6,
                  child: Container(
                    width: 75,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size(75, 65),
                  painter: Chest3DPainter(),
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut)
        .animate()
        .fadeIn(delay: (100 + index * 80).ms, duration: 400.ms)
        .scale(
          delay: (100 + index * 80).ms,
          duration: 500.ms,
          begin: const Offset(0.5, 0.5),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeOutBack,
        );
  }

  LinearGradient _getNodeGradient() {
    final baseColor = nodeColor ?? const Color(0xFFA4D65E); // Default green

    switch (type) {
      case MissionNodeType.locked:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8E8E8), Color(0xFFBDBDBD), Color(0xFF9E9E9E)],
          stops: [0.0, 0.5, 1.0],
        );
      case MissionNodeType.unlocked:
      case MissionNodeType.inProgress:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withValues(alpha: 0.8),
            baseColor,
            baseColor.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.5, 1.0],
        );
      case MissionNodeType.completed:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withValues(alpha: 0.6),
            baseColor.withValues(alpha: 0.8),
            baseColor.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        );
      case MissionNodeType.chest:
        return const LinearGradient(colors: [Colors.grey, Colors.grey]);
    }
  }

  Color _getNodeColor() {
    final baseColor =
        nodeColor ?? const Color(0xFF7FA891); // Default green shade

    switch (type) {
      case MissionNodeType.locked:
        return const Color(0xFFBDBDBD);
      case MissionNodeType.unlocked:
      case MissionNodeType.inProgress:
      case MissionNodeType.completed:
        return baseColor;
      case MissionNodeType.chest:
        return Colors.grey;
    }
  }

  Widget _getNodeIcon() {
    final iconColor = Colors.white;
    final iconSize = 36.0;

    switch (type) {
      case MissionNodeType.locked:
        return Icon(Icons.lock_rounded, color: iconColor, size: iconSize);
      case MissionNodeType.unlocked:
      case MissionNodeType.inProgress:
        return Icon(Icons.star_rounded, color: iconColor, size: iconSize);
      case MissionNodeType.completed:
        return Icon(Icons.check_rounded, color: iconColor, size: iconSize);
      case MissionNodeType.chest:
        return const SizedBox.shrink();
    }
  }
}

class YellowRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final yellowPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy + 1), radius: radius),
      -math.pi / 2,
      math.pi * 0.7,
      false,
      shadowPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 0.7,
      false,
      yellowPaint,
    );
  }

  @override
  bool shouldRepaint(YellowRingPainter oldDelegate) => false;
}

class Chest3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final bodyGradient = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB0B0B0), Color(0xFF9E9E9E), Color(0xFF757575)],
          ).createShader(
            Rect.fromCenter(
              center: Offset(center.dx, center.dy + 5),
              width: 55,
              height: 45,
            ),
          );

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 5),
        width: 55,
        height: 45,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyGradient);

    final lidGradient = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9E9E9E), Color(0xFF757575), Color(0xFF616161)],
          ).createShader(
            Rect.fromCenter(
              center: Offset(center.dx, center.dy - 12),
              width: 57,
              height: 18,
            ),
          );

    final lidRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 12),
        width: 57,
        height: 18,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(lidRect, lidGradient);

    final lockGradient = Paint()
      ..shader =
          const RadialGradient(
            colors: [Color(0xFF808080), Color(0xFF616161), Color(0xFF424242)],
          ).createShader(
            Rect.fromCircle(
              center: Offset(center.dx, center.dy + 8),
              radius: 10,
            ),
          );

    canvas.drawCircle(Offset(center.dx, center.dy + 8), 10, lockGradient);

    final keyholePaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx, center.dy + 8), 4, keyholePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - 16),
          width: 45,
          height: 6,
        ),
        const Radius.circular(3),
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(Chest3DPainter oldDelegate) => false;
}
