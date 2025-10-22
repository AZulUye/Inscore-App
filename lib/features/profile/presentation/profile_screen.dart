import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:inscore_app/core/app_routes.dart';
import 'package:inscore_app/models/user.dart';
import 'package:inscore_app/providers/user_provider.dart';
import 'package:inscore_app/features/profile/presentation/widget/point_card.dart';
import '../presentation/widget/social_media_section.dart';
import '../presentation/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize with user data from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = context.read<ProfileProvider>();
      final userProvider = context.read<UserProvider>();

      // Check if user is authenticated and load user data
      await userProvider.isAuthenticated();

      // Use user data from UserProvider if available
      if (userProvider.user != null) {
        profileProvider.initProfile(userProvider.user!);
      } else {
        // If no user is logged in, initialize with empty user
        profileProvider.initProfile(User.empty());
      }

      // Fetch user score and metrics
      profileProvider.fetchUserScore();
      profileProvider.fetchInstagramMetrics();
      profileProvider.fetchFacebookMetrics();
    });
  }

  String _getDisplayName(User? user) {
    if (user != null && user.name.isNotEmpty) {
      return user.name;
    }
    return 'User';
  }

  String? _getDisplayEmail(User? user) {
    if (user != null && user.email.isNotEmpty) {
      return user.email;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileProvider, UserProvider>(
      builder: (context, profileProvider, userProvider, child) {
        // Show loading indicator if any provider is loading or user data is not available
        if (profileProvider.isLoading ||
            userProvider.isLoading ||
            profileProvider.currentUser == null ||
            userProvider.user == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat profil...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background container with profile image
                      Container(
                        height: 320,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          image:
                              profileProvider.currentUser?.avatar != null &&
                                  profileProvider
                                      .currentUser!
                                      .avatar!
                                      .isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                    profileProvider.currentUser!.avatar!,
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    // Handle error silently, will show green background
                                  },
                                )
                              : null,
                        ),
                        child:
                            profileProvider.currentUser?.avatar == null ||
                                profileProvider.currentUser!.avatar!.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 120,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      // Overlay gradient for better text readability
                      Container(
                        height: 320,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                context.go(AppRoutes.main);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 24,
                                  color:
                                      Theme.of(context).iconTheme.color ??
                                      Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.go(AppRoutes.editProfile);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 24,
                                  color:
                                      Theme.of(context).iconTheme.color ??
                                      Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          _getDisplayName(profileProvider.currentUser),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                        ),
                        if (_getDisplayEmail(profileProvider.currentUser) !=
                            null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _getDisplayEmail(profileProvider.currentUser)!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        SocialMediaSection(
                          title: 'Instagram',
                          iconColor: Colors.pink,
                          iconData: Icons.camera_alt,
                          username:
                              profileProvider.instagramMetrics?.username ??
                              'None',
                          followers:
                              (profileProvider.instagramMetrics?.followers ??
                                      '0')
                                  .toString(),
                          engagementRate:
                              (profileProvider
                                          .instagramMetrics
                                          ?.engagementRate ??
                                      '0.0')
                                  .toString(),
                          engagementPerPost:
                              (profileProvider
                                          .instagramMetrics
                                          ?.engagementPerPost ??
                                      '0')
                                  .toString(),
                          reachRatio:
                              (profileProvider.instagramMetrics?.reachRatio ??
                                      '0.0')
                                  .toString(),
                        ),

                        const SizedBox(height: 8),
                        SocialMediaSection(
                          title: 'Facebook',
                          iconColor: Colors.blue,
                          iconData: Icons.facebook,
                          username:
                              profileProvider.facebookMetrics?.username ??
                              'None',
                          followers:
                              (profileProvider.facebookMetrics?.followers ??
                                      '0')
                                  .toString(),
                          engagementRate:
                              (profileProvider
                                          .facebookMetrics
                                          ?.engagementRate ??
                                      '0.0')
                                  .toString(),
                          engagementPerPost:
                              (profileProvider
                                          .facebookMetrics
                                          ?.engagementPerPost ??
                                      '0')
                                  .toString(),
                          reachRatio:
                              (profileProvider.facebookMetrics?.reachRatio ??
                                      '0.0')
                                  .toString(),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Scores',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.0,
                          padding: EdgeInsets.zero,
                          children: [
                            PointCard(
                              icon: Icons.camera_alt_rounded,
                              score:
                                  profileProvider.userScore?.instagramScore
                                      .toString() ??
                                  '0',
                              label: 'Instagram Score',
                            ),
                            PointCard(
                              icon: Icons.facebook,
                              score:
                                  profileProvider.userScore?.facebookScore
                                      .toString() ??
                                  '0',
                              label: 'Facebook Score',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        PointCard(
                          icon: Icons.access_time,
                          score:
                              profileProvider.userScore?.finalScore
                                  .toString() ??
                              '0',
                          label: 'Final Score',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
