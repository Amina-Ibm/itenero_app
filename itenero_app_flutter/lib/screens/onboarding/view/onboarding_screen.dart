import 'package:flutter/material.dart';
import 'package:itenero_app_flutter/screens/onboarding/widgets/onboarding_container.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: onboardingContainer(context)
          ),
        ],
      ),
    );
  }
}
