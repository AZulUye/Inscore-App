import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../providers/social_media_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../core/exception_handler.dart';
import '../core/app_routes.dart';
import '../shared/custom_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Check connection status when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SocialMediaProvider>().checkConnectionStatus();
    });
  }

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
                title: 'Delete Account',
                onTap: () => context.go(AppRoutes.deleteAccount),
              ),
              Consumer<SocialMediaProvider>(
                builder: (context, socialMediaProvider, child) {
                  return _buildSocialMediaTile(
                    context,
                    title: 'Instagram',
                    icon: Icons.camera_alt,
                    iconColor: Colors.pink,
                    isConnected: socialMediaProvider.isInstagramConnected,
                    isLoading:
                        socialMediaProvider.isInstagramConnecting ||
                        socialMediaProvider.isCheckingStatus,
                    onToggle: () =>
                        socialMediaProvider.connectInstagram(context),
                  );
                },
              ),
              Consumer<SocialMediaProvider>(
                builder: (context, socialMediaProvider, child) {
                  return _buildSocialMediaTile(
                    context,
                    title: 'Facebook',
                    icon: Icons.facebook,
                    iconColor: Colors.blue,
                    isConnected: socialMediaProvider.isFacebookConnected,
                    isLoading:
                        socialMediaProvider.isFacebookConnecting ||
                        socialMediaProvider.isCheckingStatus,
                    onToggle: () =>
                        socialMediaProvider.connectFacebook(context),
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

  Widget _buildSocialMediaTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isConnected,
    bool isLoading = false,
    required VoidCallback onToggle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title),
      subtitle: Text(
        isConnected ? 'Connected' : 'Not Connected',
        style: TextStyle(
          color: isConnected ? Colors.green : Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: isLoading ? null : onToggle,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected ? Colors.red : Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                isConnected ? 'Disconnect' : 'Connect',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
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
