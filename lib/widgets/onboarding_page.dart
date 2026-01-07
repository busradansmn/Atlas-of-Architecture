import 'package:flutter/material.dart';
import 'package:mimari_atlas/screens/onboarding/onboarding_screen.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_size.dart';

Widget buildPage(OnboardingData data, dynamic context) {
  final r = ResponsiveSize(context);

  return Padding(
    padding: const EdgeInsets.all(40.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: r.wp(30),
          height: r.wp(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple.withOpacity(0.2),
                AppTheme.secondaryPurple.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(80),
          ),
          child: Icon(
            data.icon,
            size: r.wp(15),
            color: AppTheme.primaryPurple,
          ),
        ),
        r.verticalSpaceMedium,
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.sp(28),
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        r.verticalSpaceSmall,
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.sp(16),
            color: AppTheme.textLight,
            letterSpacing: 1.2,
          ),
        ),
      ],
    ),
  );
}