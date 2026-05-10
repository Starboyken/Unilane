import 'package:flutter/material.dart';

import 'package:unitrade/features/auth/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _logoScale;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _flashOpacity;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    final curvedAnimation = CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    );

    _logoScale = Tween<double>(begin: 0.96, end: 1.04).animate(curvedAnimation);
    _contentOpacity = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(curvedAnimation);
    _flashOpacity = Tween<double>(
      begin: 0.0,
      end: 0.16,
    ).animate(curvedAnimation);

    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF173CFF), Color(0xFF6F00FF)],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: -120,
                  left: -70,
                  child: _GlowBubble(size: 260),
                ),
                const Positioned(
                  right: -110,
                  bottom: -110,
                  child: _GlowBubble(size: 280),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _flashOpacity.value,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topCenter,
                            radius: 1.1,
                            colors: [Colors.white, Colors.transparent],
                            stops: [0, 0.72],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: Opacity(
                      opacity: _contentOpacity.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: _logoScale.value,
                            child: Container(
                              width: 104,
                              height: 104,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF8E8D0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    blurRadius: 28,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.school_outlined,
                                size: 48,
                                color: Color(0xFF1640E8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'UniLane',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFF8E8D0),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Trusted campus marketplace and student living',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFE9DBFF),
                            ),
                          ),
                        ],
                      ),
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

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
