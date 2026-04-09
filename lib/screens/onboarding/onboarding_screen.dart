import 'package:flutter/material.dart';
import 'package:mimari_atlas/utils/responsive_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/app_theme.dart';
import '../../widgets/onboarding_page.dart';
import 'dart:async';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  Timer? _buttonAnimationTimer;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.architecture,
      title: 'Mimari Atlas\'a Hoş Geldiniz',
      description:
          'Mimarlık dünyasında yolculuğunuza başlayın. Yapay zeka destekli asistanımızla mimarlık sorularınıza anında cevap alın.',
    ),
    OnboardingData(
      icon: Icons.chat_bubble_outline,
      title: 'AI Destekli Sohbet',
      description:
          'Mimari tasarım, tarih, teoriler ve teknik sorularınız için AI asistanınızla konuşun. Her zaman yanınızda!',
    ),
    OnboardingData(
      icon: Icons.trending_up,
      title: 'Trendleri Takip Edin',
      description:
          'Mimarlık dünyasındaki son trendleri keşfedin, ilham alın ve bilgilerinizi güncel tutun.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -8.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && _currentPage < _pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else if (mounted && _currentPage == _pages.length - 1) {
        _bounceController.repeat(reverse: true);
      }
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/main',
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _buttonAnimationTimer?.cancel();
    _bounceController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveSize(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildGecButton(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _startAutoScroll();
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return buildPage(_pages[index], context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const WormEffect(
                  dotColor: AppTheme.lightPurple,
                  activeDotColor: AppTheme.primaryPurple,
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 16,
                ),
              ),
            ),
            _buildNextButton(r)
          ],
        ),
      ),
    );
  }

  Padding _buildGecButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: _completeOnboarding,
          child: const Text(
            'Geç',
            style: TextStyle(
              color: AppTheme.primaryPurple,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildNextButton(ResponsiveSize r) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: child,
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: r.wp(10),
          child: ElevatedButton(
            onPressed: () {
              _autoScrollTimer?.cancel();
              _buttonAnimationTimer?.cancel();
              _bounceController.stop();

              if (_currentPage == _pages.length - 1) {
                _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              _currentPage == _pages.length - 1 ? 'Başla' : 'İleri',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
