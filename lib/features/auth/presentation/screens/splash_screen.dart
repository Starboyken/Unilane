import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/auth/data/app_launch_repository.dart';
import 'package:unilane/features/auth/presentation/providers/auth_provider.dart';
import 'package:unilane/features/auth/presentation/screens/login_screen.dart';
import 'package:unilane/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:unilane/features/main/presentation/screens/main_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _float;
  late final Animation<double> _progress;
  late final Future<bool> _hasSeenOnboardingFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);

    final ease = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _fade = Tween<double>(begin: 0.88, end: 1.0).animate(ease);
    _scale = Tween<double>(begin: 0.97, end: 1.0).animate(ease);
    _float = Tween<double>(begin: 8, end: 0).animate(ease);
    _progress = Tween<double>(begin: 0.38, end: 0.96).animate(ease);
    _hasSeenOnboardingFuture = _loadOnboardingFlag();

    Timer(const Duration(milliseconds: 2600), _routeAfterSplash);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _loadOnboardingFlag() async {
    try {
      final launchRepository = context.read<AppLaunchRepository>();
      return launchRepository.hasSeenOnboarding();
    } catch (_) {
      return false;
    }
  }

  Future<void> _routeAfterSplash() async {
    final hasSeenOnboarding = await _hasSeenOnboardingFuture;
    if (!mounted) return;

    final authUser = context.read<AuthProvider>().currentUser;

    Widget nextScreen;
    if (authUser != null) {
      nextScreen = const MainShellScreen();
    } else if (hasSeenOnboarding) {
      nextScreen = const LoginScreen();
    } else {
      nextScreen = const OnboardingScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF07152D),
                  Color(0xFF0F3D91),
                  Color(0xFF1D4ED8),
                ],
                stops: [0.0, 0.56, 1.0],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: -90,
                  left: -70,
                  child: _GlowOrb(
                    size: 220,
                    colors: [Color(0x26FFFFFF), Color(0x00000000)],
                  ),
                ),
                const Positioned(
                  right: -80,
                  bottom: 100,
                  child: _GlowOrb(
                    size: 180,
                    colors: [Color(0x2A93C5FF), Color(0x00000000)],
                  ),
                ),
                const Positioned(
                  left: 28,
                  bottom: 86,
                  child: _GlowOrb(
                    size: 96,
                    colors: [Color(0x22FFFFFF), Color(0x00000000)],
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _DotGridPainter(opacity: 0.07)),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                    child: Column(
                      children: [
                        const Spacer(),
                        Transform.translate(
                          offset: Offset(0, _float.value),
                          child: Opacity(
                            opacity: _fade.value,
                            child: Transform.scale(
                              scale: _scale.value,
                              child: _HeroMark(progress: _progress.value),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _CenterLabel(
                          opacity: _fade.value,
                          text: 'Verified student marketplace • lodges • chat',
                        ),
                        const SizedBox(height: 18),
                        Opacity(
                          opacity: _fade.value,
                          child: const Column(
                            children: [
                              Text(
                                'UniLane',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Trusted campus marketplace and student living',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD7E4FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Opacity(
                          opacity: _fade.value,
                          child: Column(
                            children: [
                              const Text(
                                'Preparing your campus feed',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD9E6FF),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  height: 8,
                                  color: Colors.white.withValues(alpha: 0.14),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: _progress.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFDE68A),
                                              Color(0xFFF8FAFC),
                                              Color(0xFF93C5FD),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Safe • Simple • Student-first',
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Color(0xFFB8CCF5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _CenterLabel extends StatelessWidget {
  const _CenterLabel({required this.opacity, required this.text});

  final double opacity;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.2,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _HeroMark extends StatelessWidget {
  const _HeroMark({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 206,
      height: 206,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 206,
            height: 206,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0.02),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          Container(
            width: 164,
            height: 164,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.20 + (progress * 0.04)),
                  Colors.white.withValues(alpha: 0.08 + (progress * 0.03)),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8FAFC).withValues(alpha: 0.96),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1D4ED8),
                          const Color(0xFF3B82F6).withValues(alpha: 0.96),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.storefront_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                  Positioned(
                    top: 40,
                    right: 30,
                    child: _MiniBadge(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      backgroundColor: const Color(0xFF0F172A),
                    ),
                  ),
                  Positioned(
                    bottom: 34,
                    left: 28,
                    child: _MiniBadge(
                      icon: Icons.home_work_outlined,
                      color: const Color(0xFF1D4ED8),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(icon, size: 17, color: color),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    const spacing = 34.0;
    for (double y = 24; y < size.height; y += spacing) {
      for (double x = 24; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.6, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}
