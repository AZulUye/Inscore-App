import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/home_model.dart';

class WeeklyScoreTrendChart extends StatelessWidget {
  final Charts chartData;

  const WeeklyScoreTrendChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Score Trend',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              _createChartData(context),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _createChartData(BuildContext context) {
    final theme = Theme.of(context);
    final spots = <FlSpot>[];

    // Map data to spots based on day of week (0=Monday, 6=Sunday)
    for (var data in chartData.dailyScoreSeries) {
      final date = DateTime.parse(data.date);
      // weekday: 1=Monday, 7=Sunday -> convert to 0-6 (0=Monday, 6=Sunday)
      final dayIndex = date.weekday - 1;

      final value = data.value ?? 0.0;
      spots.add(FlSpot(
        dayIndex.toDouble(),
        value,
      ));
    }

    // Calculate max for better scaling (handle null values)
    final values = chartData.dailyScoreSeries
        .map((e) => e.value ?? 0.0)
        .toList();
    final maxValue = values.isEmpty ? 100.0 : values.reduce((a, b) => a > b ? a : b);

    // Y-axis from 0 to rounded max
    final maxY = ((maxValue / 10).ceil() + 1) * 10.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[300],
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              final index = value.toInt();
              
              if (index < 0 || index >= dayNames.length) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  dayNames[index],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: theme.colorScheme.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.2),
                theme.colorScheme.primary.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}