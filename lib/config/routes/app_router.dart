import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_layout.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case AppRoutes.splash:
      //   return MaterialPageRoute(builder: (_) => const SplashPage());
      // case AppRoutes.login:
      //   return RightRouting(const LoginPage());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const HomeLayout());
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
