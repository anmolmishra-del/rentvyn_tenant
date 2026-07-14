import 'package:flutter/material.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import '../../features/main_navigation/views/main_nav_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String mainNav = '/main_nav';
  

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case mainNav:
        return MaterialPageRoute(builder: (_) => const MainNavView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
