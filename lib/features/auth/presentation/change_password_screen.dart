import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/app_routes.dart';
import '../../../providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.main),
        ),
        title: const Text('Change  Password'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a New Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter and confirm your new password to\nregain access',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),

              // Old password
              const _FieldLabel('Old Password'),
              const SizedBox(height: 8),
              _PasswordField(
                hintText: '••••••••',
                obscureText: _obscureOld,
                controller: _oldPasswordController,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
              ),

              const SizedBox(height: 20),

              // New password
              const _FieldLabel('New password'),
              const SizedBox(height: 8),
              _PasswordField(
                hintText: '••••••••',
                obscureText: _obscureNew,
                controller: _newPasswordController,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),

              const SizedBox(height: 20),

              // Confirm new password
              const _FieldLabel('Confirm new password'),
              const SizedBox(height: 8),
              _PasswordField(
                hintText: '••••••••',
                obscureText: _obscureConfirm,
                controller: _confirmPasswordController,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),

              const SizedBox(height: 28),

              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              final oldPwd = _oldPasswordController.text.trim();
                              final newPwd = _newPasswordController.text.trim();
                              final confirmPwd = _confirmPasswordController.text
                                  .trim();

                              if (oldPwd.isEmpty ||
                                  newPwd.isEmpty ||
                                  confirmPwd.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua kolom wajib diisi.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (newPwd.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Kata sandi baru minimal 6 karakter.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (newPwd != confirmPwd) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Konfirmasi kata sandi salah.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              try {
                                await context
                                    .read<AuthProvider>()
                                    .changePassword(
                                      currentPassword: oldPwd,
                                      newPassword: newPwd,
                                      newPasswordConfirmation: confirmPwd,
                                    );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Kata sandi berhasil diubah.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context.go(AppRoutes.settings);
                              } catch (e) {
                                if (!context.mounted) return;
                                final msg =
                                    auth.error ?? 'Gagal mengubah kata sandi.';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(msg),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Change'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final VoidCallback onToggle;
  final TextEditingController? controller;

  const _PasswordField({
    required this.hintText,
    required this.obscureText,
    required this.onToggle,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: '•',
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
