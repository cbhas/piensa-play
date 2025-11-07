import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressCircle extends StatelessWidget {
  final double progress;
  final Map<String, double> monthlyProgress;

  const ProgressCircle({
    super.key,
    required this.progress,
    required this.monthlyProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'Tu Avance\nGeneral',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(height: 24),
          CustomPaint(
            size: const Size(160, 160),
            painter: _CircularProgressPainter(progress: progress),
            child: SizedBox(
              width: 160,
              height: 160,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${(progress * 100).toInt()}%',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                    Text('Completado', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...monthlyProgress.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(width: 40, child: Text(entry.key, style: TextStyle(fontSize: 14, color: Colors.grey.shade700))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: entry.value,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            entry.value >= 0.7 ? Colors.green.shade400 : const Color(0xFFF4D03F)),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                      width: 40,
                      child: Text('${(entry.value * 100).toInt()}%',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius, backgroundPaint);
    final progressPaint = Paint()
      ..color = const Color(0xFF6EC6FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
