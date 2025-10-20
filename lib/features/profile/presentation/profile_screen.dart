import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:inscore_app/core/app_routes.dart';
import 'package:inscore_app/models/user.dart';
import 'package:inscore_app/features/profile/presentation/widget/point_card.dart'
    show PointCard;
import '../presentation/widget/social_media_section.dart';
import 'profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize with demo user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.initProfile(User.demo());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 320,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                        ),
                      ),
                      Positioned(
                        bottom: -53,
                        left: 0,
                        right: 0,
                        child: Center(
                          child:
                              provider.currentUser?.avatar != null &&
                                  provider.currentUser?.avatar?.isNotEmpty ==
                                      true
                              ? Container(
                                  width: 320,
                                  height: 320,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      provider.currentUser!.avatar!,
                                      width: 320,
                                      height: 320,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person_2_sharp,
                                              size: 320,
                                              color: Colors.white,
                                            );
                                          },
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.person_2_sharp,
                                  size: 320,
                                  color: Colors.white,
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
                                ),
                                child: const Icon(Icons.arrow_back, size: 24),
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
                                child: const Icon(
                                  Icons.edit,
                                  size: 24,
                                  color: Colors.white,
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
                          'Linkebin',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                        ),
                        const SizedBox(height: 24),

                        SocialMediaSection(
                          title: 'Instagram',
                          iconColor: Colors.pink,
                          iconData: Icons.camera_alt,
                          username: 'username',
                          followers: '1965',
                        ),

                        const SizedBox(height: 8),
                        SocialMediaSection(
                          title: 'Facebook',
                          iconColor: Colors.blue,
                          iconData: Icons.facebook,
                          username: 'username',
                          followers: '1965',
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
                          children: const [
                            PointCard(
                              icon: Icons.camera_alt_rounded,
                              score: '9000',
                              label: 'Instagram Score',
                            ),
                            PointCard(
                              icon: Icons.facebook,
                              score: '9000',
                              label: 'Facebook Score',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const PointCard(
                          icon: Icons.access_time,
                          score: '9000',
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
