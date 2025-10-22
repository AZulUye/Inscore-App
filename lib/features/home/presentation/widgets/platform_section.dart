import 'package:flutter/material.dart';
import '../../domain/home_model.dart';
import 'platform_card.dart';

class PlatformSection extends StatelessWidget {
  final List<PlatformConnection> platforms;

  const PlatformSection({super.key, required this.platforms});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: platforms.map((platform) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PlatformCard(platform: platform),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}