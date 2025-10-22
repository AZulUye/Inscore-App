import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/home_model.dart';
import 'today_score_card.dart';
import 'platform_section.dart';
import 'weekly_comparison_card.dart';
import 'weekly_score_trend_chart.dart';

class HomeContent extends StatelessWidget {
  final HomeData homeData;

  const HomeContent({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${homeData.user.name}!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Today's Score Card
        TodayScoreCard(todayScore: homeData.today),
        const SizedBox(height: 24),

        // Platform Connections
        PlatformSection(platforms: homeData.platforms),
        const SizedBox(height: 24),

        // Weekly Comparison
        WeeklyComparisonCard(comparison: homeData.weeklyComparison),
        const SizedBox(height: 24),

        // Weekly Score Trend Chart
        WeeklyScoreTrendChart(chartData: homeData.charts),
        const SizedBox(height: 24),
      ],
    );
  }
}