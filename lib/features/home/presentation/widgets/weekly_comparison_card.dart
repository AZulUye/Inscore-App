import 'package:flutter/material.dart';
import '../../domain/home_model.dart';

class WeeklyComparisonCard extends StatelessWidget {
  final WeeklyComparison comparison;

  const WeeklyComparisonCard({super.key, required this.comparison});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = comparison.deltaPercent >= 0;
    final deltaText = '${isPositive ? '+' : ''}${comparison.deltaPercent.toStringAsFixed(1)}% from last week';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            deltaText,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      comparison.lastWeekAvgScore.toInt().toString(),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last Week',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_double_arrow_right,
                size: 32,
                color: Colors.grey[400],
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      comparison.thisWeekAvgScore.toInt().toString(),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This Week',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}