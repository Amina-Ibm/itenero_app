part of 'splash_screen.dart';

abstract class _SplashScreenProps extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }
}
