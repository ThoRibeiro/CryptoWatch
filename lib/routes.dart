import 'package:flutter/material.dart';
import 'views/welcome_view.dart';
import 'views/home_view.dart';
import 'views/crypto_detail_view.dart';
import 'views/settings_view.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final name = routeSettings.name;

    if (name == AppRoutes.welcome) {
      return MaterialPageRoute(builder: (_) => const WelcomeView());
    } else if (name == AppRoutes.home) {
      return MaterialPageRoute(builder: (_) => const HomeView());
    } else if (name == AppRoutes.detail) {
      final String cryptoId = routeSettings.arguments as String;
      return MaterialPageRoute(builder: (_) => CryptoDetailView(cryptoId: cryptoId));
    } else if (name == AppRoutes.settings) {
      return MaterialPageRoute(builder: (_) => const SettingsView());
    } else {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Page non trouvée')),
        ),
      );
    }
  }
}
