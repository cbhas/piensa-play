import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/audio_service.dart';

/// Animated mascot button that plays audio when clicked
/// Shows vizcacha mascot with talking animation
class MascotAudioButton extends StatefulWidget {
  final String audioFileName;
  final double size;
  final Color? backgroundColor;

  const MascotAudioButton({
    super.key,
    required this.audioFileName,
    this.size = 60.0,
    this.backgroundColor,
  });

  @override
  State<MascotAudioButton> createState() => _MascotAudioButtonState();
}

class _MascotAudioButtonState extends State<MascotAudioButton>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;
  late AnimationController _talkingController;

  @override
  void initState() {
    super.initState();
    _talkingController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _talkingController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    // Check if this specific audio is currently playing
    final isThisAudioPlaying =
        _audioService.isPlaying &&
        _audioService.currentAudio == 'audio/mascot/${widget.audioFileName}';

    if (isThisAudioPlaying) {
      // Stop if this audio is already playing
      await _audioService.stop();
      _talkingController.stop();
      _talkingController.reset();
      setState(() {
        _isPlaying = false;
      });
    } else {
      // Play audio (this will stop any other audio automatically)
      setState(() {
        _isPlaying = true;
      });
      _talkingController.repeat(reverse: true);

      await _audioService.playMascotAudio(widget.audioFileName);

      // Stop animation when audio finishes
      if (mounted) {
        _talkingController.stop();
        _talkingController.reset();
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAudio,
      child:
          Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Vizcacha mascot image
                    AnimatedBuilder(
                      animation: _talkingController,
                      builder: (context, child) {
                        // Scale slightly when talking
                        final scale = _isPlaying
                            ? 1.0 + (_talkingController.value * 0.1)
                            : 1.0;
                        return Transform.scale(
                          scale: scale,
                          child: Image.asset(
                            'assets/images/mascot.png',
                            width: widget.size * 0.7,
                            height: widget.size * 0.7,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to icon if image not found
                              return Icon(
                                Icons.volume_up,
                                size: widget.size * 0.5,
                                color: Colors.blue,
                              );
                            },
                          ),
                        );
                      },
                    ),

                    // Sound waves when playing
                    if (_isPlaying)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _talkingController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: SoundWavesPainter(
                                progress: _talkingController.value,
                                color: Colors.blue.withValues(alpha: 0.3),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              )
              .animate(target: _isPlaying ? 1 : 0)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 200.ms,
              ),
    );
  }
}

/// Custom painter for sound waves around the mascot
class SoundWavesPainter extends CustomPainter {
  final double progress;
  final Color color;

  SoundWavesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw 3 expanding circles
    for (int i = 0; i < 3; i++) {
      final radius = (size.width / 2) * (0.6 + (progress * 0.4) + (i * 0.15));
      final opacity = 1.0 - ((progress + (i * 0.3)) % 1.0);

      paint.color = color.withValues(alpha: opacity * 0.5);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(SoundWavesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
