import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mediaSize = MediaQuery.sizeOf(context);
          final maxWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : mediaSize.width;
          final maxHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : mediaSize.height;

          return SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Color
                Positioned.fill(
                  child: Container(color: AppColors.background),
                ),
                // Purple Glow Top-Left
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: -100 * _animation.value,
                      left: -100 * _animation.value,
                      child: Transform.scale(
                        scale: _animation.value,
                        child: Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.purple.withOpacity(0.25),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Neon Green Glow Bottom-Right
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      bottom: -80,
                      right: -80 * _animation.value,
                      child: Transform.scale(
                        scale: _animation.value,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.neonGreen.withOpacity(0.12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Heavy Blur Overlay (Glassmorphism effect)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                // Actual UI Content
                Positioned.fill(
                  child: SafeArea(
                    child: SizedBox(
                      width: maxWidth,
                      height: maxHeight,
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
