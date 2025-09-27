import 'package:flutter/material.dart';

class AnimatedFade extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedFade({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedFade> createState() => _AnimatedFadeState();
}

class _AnimatedFadeState extends State<AnimatedFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: widget.child);
  }
}
