import 'package:flutter/material.dart';
import '../../domain/home_model.dart';

class PlatformCard extends StatelessWidget {
  final PlatformConnection platform;

  const PlatformCard({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInstagram = platform.platform.toLowerCase() == 'instagram';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isInstagram
                    ? [
                        const Color(0xFF833AB4),
                        const Color(0xFFFD1D1D),
                        const Color(0xFFFCAF45),
                      ]
                    : [
                        const Color(0xFF1877F2),
                        const Color(0xFF1877F2),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isInstagram ? Icons.camera_alt : Icons.facebook,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            platform.platform.substring(0, 1).toUpperCase() +
                platform.platform.substring(1),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                platform.connected ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: platform.connected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  platform.connected ? 'Connected' : 'Disconnect',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: platform.connected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (platform.account != null) ...[
            const SizedBox(height: 4),
            Text(
              platform.account!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}