part of 'splash_screen.dart';

abstract class _SplashScreenProps extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    await Future.delayed(const Duration(seconds: 2));
    final completed = await OnboardingService.isOnboardingCompleted();

    if (completed) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }
}
