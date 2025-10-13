import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../core/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
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
                onTap: () {
                  // TODO: Navigate to change password screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Change password feature coming soon'),
                    ),
                  );
                },
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
          color: Colors.grey.shade50,
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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement sign out logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully')),
                );
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
