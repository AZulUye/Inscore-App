import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inscore_app/core/app_routes.dart';
import 'package:inscore_app/features/profile/presentation/widget/point_card.dart'
    show PointCard;
import '../presentation/widget/social_media_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                    decoration: const BoxDecoration(color: Colors.greenAccent),
                  ),
                  Positioned(
                    bottom: -53,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Icon(
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
                    child: InkWell(
                      onTap: () {
                        context.go(AppRoutes.main);
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back, size: 24),
                      ),
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
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 28),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
  }
}
