import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itenero_app_flutter/core/core.dart';
import 'package:itenero_app_flutter/routes/routes.dart';
import 'package:itenero_app_flutter/screens/onboarding/service/onboarding_service.dart';

part 'splash_screen_props.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends _SplashScreenProps {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo-white.png',
              width: SizeConfig.screenWidth * 0.8,
            ),
            Text(
              "Smart itineraries. perfectly planned for you.",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: SizeConfig.smallText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
