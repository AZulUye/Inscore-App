import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:inscore_app/screens/main_screen.dart';
import 'package:inscore_app/services/api_service.dart';
import 'package:provider/provider.dart';

import '../features/profile/presentation/profile_provider.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../features/auth/presentation/change_password_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/edit_profile_provider.dart';

class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String main = '/main';
  static const String changePassword = '/change-password';
  static const String editProfile = '/edit-profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: intro,
        name: 'intro',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: changePassword,
        name: 'change_password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: editProfile,
        name: 'edit_profile',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => EditProfileProvider(),
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => ProfileProvider(context.read<ApiService>()),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
