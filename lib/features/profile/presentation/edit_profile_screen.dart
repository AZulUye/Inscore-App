import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:inscore_app/core/app_routes.dart';
import 'package:inscore_app/models/user.dart';
import 'edit_profile_provider.dart';
import 'widget/form_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with demo user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EditProfileProvider>();
      provider.initProfile(User.demo());
      _usernameController.text = User.demo().name;
      _emailController.text = User.demo().email;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.profile),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Consumer<EditProfileProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Your Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Update your profile information and\nprofile picture',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profile Picture Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: provider.profileImage != null
                                  ? FileImage(provider.profileImage!)
                                  : (provider.currentUser?.avatar != null
                                            ? NetworkImage(
                                                provider.currentUser!.avatar!,
                                              )
                                            : null)
                                        as ImageProvider?,
                              child:
                                  provider.profileImage == null &&
                                      (provider.currentUser?.avatar == null ||
                                          provider.currentUser!.avatar!.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: provider.pickProfileImage,
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to change profile picture',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Username Field
                  const FieldLabel('Username'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Enter your username',
                    controller: _usernameController,
                    onChanged: provider.setUsername,
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  const FieldLabel('Email'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Enter your email',
                    controller: _emailController,
                    onChanged: provider.setEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 28),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _handleUpdateProfile(context, provider),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Update Profile'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleUpdateProfile(
    BuildContext context,
    EditProfileProvider provider,
  ) async {
    FocusScope.of(context).unfocus();

    try {
      await provider.updateProfile();
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            content: Text('Profile berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          this.context.go(AppRoutes.profile);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }
}
