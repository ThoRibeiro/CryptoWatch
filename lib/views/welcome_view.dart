import 'package:flutter/material.dart';
import 'package:project/theme/app_colors.dart';
import '../views/home_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHomeWithFade() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
        return FadeTransition(opacity: fade, child: child);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'lib/assets/logo-white.png',
                height: 160,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'CryptoWatch',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Suivez vos cryptos en temps réel',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _navigateToHomeWithFade,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Entrer',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
