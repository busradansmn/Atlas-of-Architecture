import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive_size.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Otomatik geçiş (opsiyonel - butona basmak yerine)
    // Future.delayed(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     _goToOnboarding();
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToOnboarding() {
    Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryPurple,
              AppTheme.secondaryPurple,
              AppTheme.accentPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Container
                        Container(
                          width: r.wp(30),
                          height: r.wp(30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(r.wp(7.5)),
                          ),
                          child: Icon(
                            Icons.architecture,
                            size: r.wp(15),
                            color: Colors.white,
                          ),
                        ),
                        r.verticalSpaceMedium,

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.wp(10)),
                          child: Text(
                            'Mimari Atlas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: r.sp(36),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        r.verticalSpaceSmall,

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.wp(10)),
                          child: Text(
                            'Mimarlık Dünyasının Rehberi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: r.sp(16),
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        r.verticalSpaceExtraLarge,

                        SizedBox(
                          width: r.wp(45).clamp(160.0, 220.0),
                          height: r.hp(6).clamp(48.0, 60.0),
                          child: ElevatedButton(
                            onPressed: _goToOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryPurple,
                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Başla',
                              style: TextStyle(
                                fontSize: r.sp(18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}