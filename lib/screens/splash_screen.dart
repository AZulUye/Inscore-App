import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_routes.dart';
import '../providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Small delay to show splash
      await Future.delayed(const Duration(milliseconds: 3000));

      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final hasSeen = prefs.getBool('hasSeenOnboarding') ?? false;
      if (!hasSeen) {
        if (!mounted) return;
        context.go(AppRoutes.intro);
        return;
      }

      if (!mounted) return;
      final isAuthed = await context.read<UserProvider>().isAuthenticated();
      if (!mounted) return;
      context.go(isAuthed ? AppRoutes.home : AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                GestureDetector(
                  onLongPress: () async {
                    final prefs = await SharedPreferences.getInstance();
                    if (!mounted) return;
                    await prefs.remove('hasSeenOnboarding');
                    if (!mounted) return;
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(content: Text('Onboarding direset')),
                    );
                    if (!mounted) return;
                    this.context.go(AppRoutes.intro);
                  },
                  child: Image.asset(
                    'assets/images/logo/Logo.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: const [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
