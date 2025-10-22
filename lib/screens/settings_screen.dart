import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../core/exception_handler.dart';
import '../core/app_routes.dart';
import '../shared/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: CustomText(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSection(
            context,
            icon: Icons.person,
            title: 'Account',
            children: [
              _buildListTile(
                context,
                title: 'Profile',
                onTap: () => context.go(AppRoutes.profile),
              ),
              _buildListTile(
                context,
                title: 'Change Password',
                onTap: () => context.go(AppRoutes.changePassword),
              ),
              _buildListTile(
                context,
                title: 'Instagram',
                onTap: () {
                  // TODO: Navigate to Instagram integration
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Instagram integration coming soon'),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                title: 'Facebook',
                onTap: () {
                  // TODO: Navigate to Facebook integration
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Facebook integration coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notification Section
          _buildSection(
            context,
            icon: Icons.notifications,
            title: 'Notification',
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('App Notification'),
                    value:
                        true, // You can add notification preference to theme provider
                    onChanged: (value) {
                      // TODO: Implement notification toggle
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notifications ${value ? 'enabled' : 'disabled'}',
                          ),
                        ),
                      );
                    },
                    activeColor: Theme.of(context).primaryColor,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Appearance Section (Hidden but keeping dark mode toggle)
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildSection(
                context,
                icon: Icons.palette,
                title: 'Appearance',
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Switch between light and dark theme'),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Sign Out
          Center(
            child: TextButton(
              onPressed: () {
                _showSignOutDialog(context);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Section Content
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext outerContext) {
    showDialog(
      context: outerContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await outerContext.read<AuthProvider>().logout();

                  if (outerContext.mounted) {
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      const SnackBar(content: Text('Signed out successfully')),
                    );
                    outerContext.go(AppRoutes.login);
                  }
                } catch (e) {
                  final msg = ExceptionHandler.getErrorMessage(e);
                  if (outerContext.mounted) {
                    ScaffoldMessenger.of(
                      outerContext,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  }
                }
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
