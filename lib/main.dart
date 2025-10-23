import 'package:flutter/material.dart';
import 'package:inscore_app/features/auth/data/auth_repository.dart';
import 'package:inscore_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'providers/user_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/social_media_provider.dart';
import 'features/leaderboard/data/leaderboard_repository.dart';
import 'features/profile/data/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read<ApiService>()),
        ),
        Provider(
          create: (context) =>
              LeaderboardRepository(context.read<ApiService>()),
        ),
        Provider(
          create: (context) => ProfileRepository(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LeaderboardProvider(context.read<LeaderboardRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SocialMediaProvider(context.read<ProfileRepository>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Inscore App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
