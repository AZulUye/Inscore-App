import 'package:flutter/material.dart';
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
                    bottom: -54,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: const Icon(
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
                      onTap: () {}, // fungsi kembali
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
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
                      'Points',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8,
                      padding: EdgeInsets.zero,
                      children: [
                        PointCard(
                          icon: Icons.access_time,
                          score: '9000',
                          label: 'Daily Score',
                        ),
                        PointCard(
                          icon: Icons.calendar_view_week,
                          score: '4500',
                          label: 'Weekly Score',
                        ),
                        PointCard(
                          icon: Icons.camera_alt,
                          score: '9000',
                          label: 'Instagram Score',
                        ),
                        PointCard(
                          icon: Icons.facebook,
                          score: '4500',
                          label: 'Facebook Score',
                        ),
                      ],
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
