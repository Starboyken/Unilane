import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/auth/data/app_launch_repository.dart';
import 'package:unilane/features/auth/presentation/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      icon: Icons.shopping_bag_outlined,
      title: 'Buy & Sell with Confidence',
      description:
          'Trade textbooks, gadgets, and everyday essentials with verified students on your campus.',
    ),
    _OnboardingItem(
      icon: Icons.home_outlined,
      title: 'Find Campus-Friendly Stays',
      description:
          'Browse student lodges and accommodation options near school with clearer details and pricing.',
    ),
    _OnboardingItem(
      icon: Icons.people_outline_rounded,
      title: 'Chat, Match, and Move Fast',
      description:
          'Message buyers, sellers, landlords, and potential roommates in one simple student app.',
    ),
  ];

  bool get _isLastPage => _currentPage == _items.length - 1;

  Future<void> _goToSignup() async {
    await context.read<AppLaunchRepository>().markOnboardingSeen();

    if (!mounted) {
      return;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const SignupScreen()));
  }

  void _handleNext() {
    if (_isLastPage) {
      _goToSignup();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _items[_currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPage(item: _items[index]);
                  },
                ),
              ),
              _PageIndicator(
                itemCount: _items.length,
                currentPage: _currentPage,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLastPage
                      ? const Text('Get Started')
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.buttonLabel),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _goToSignup(),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.item});

  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: const BoxDecoration(
            color: Color(0xFFE9F0FF),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, size: 62, color: const Color(0xFF1D4ED8)),
        ),
        const SizedBox(height: 36),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202124),
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.itemCount, required this.currentPage});

  final int itemCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  String get buttonLabel => 'Next';
}
