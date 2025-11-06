// lib/features/onboarding/presentation/widgets/animated_bubble.dart

import 'package:flutter/material.dart';

class AnimatedBubble extends StatefulWidget {
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final bool centerVertically;
  final double duration;
  final double offset;

  const AnimatedBubble({
    super.key,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.centerVertically = false,
    this.duration = 3.0,
    this.offset = 20.0,
  });

  @override
  State<AnimatedBubble> createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationY;
  late Animation<double> _animationScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.duration * 1000).toInt()),
      vsync: this,
    );

    _animationY = Tween<double>(
      begin: 0,
      end: widget.offset,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _animationScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bubble = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animationY.value),
          child: Transform.scale(
            scale: _animationScale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );

    // centrada verticalmente
    if (widget.centerVertically) {
      return Positioned(
        top: 0,
        bottom: 0,
        right: widget.right,
        left: widget.left,
        child: Center(
          child: bubble,
        ),
      );
    }

    // Posicionamiento normal
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: bubble,
    );
  }
}
