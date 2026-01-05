
import 'package:flutter/material.dart';
import 'package:itenero_app_flutter/screens/screens.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const settings = '/settings';
  static const addTrip = '/addTrip';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    onboarding: (context) => OnboardingScreen(),
  };
}
