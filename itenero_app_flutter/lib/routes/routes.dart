import 'package:flutter/material.dart';
import 'package:itenero_app_flutter/screens/screens.dart';

import '../screens/home/view/home_page.dart';
import '../screens/settings/view/settings_page.dart';

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
    addTrip: (context) => AddTripPage(),
    home: (context) => HomePage(),
    settings: (context) => SettingsPage(),
  };
}
