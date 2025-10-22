import 'package:flutter/material.dart';
import 'package:inscore_app/features/leaderboard/data/leaderboard_repository.dart';
import 'package:inscore_app/providers/leaderboard_provider.dart';
import 'package:inscore_app/features/leaderboard/presentation/leaderboard_body.dart';
import 'package:inscore_app/services/api_service.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var tabFontStyle = theme.textTheme.bodyMedium;
    var tabFontColor = theme.colorScheme.onPrimary;
    var tabTextStyle = tabFontStyle!.copyWith(color: tabFontColor);

    return MultiProvider(
      providers: [
        Provider(
          create: (context) =>
              LeaderboardRepository(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LeaderboardProvider(context.read<LeaderboardRepository>()),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: Text("Leaderboard"),
            bottom: TabBar(
              tabs: [
                Tab(child: Text("Daily", style: tabTextStyle)),

                Tab(child: Text("Weekly", style: tabTextStyle)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              LeaderboardBody(period: "daily"),
              LeaderboardBody(period: "weekly"),
            ],
          ),
        ),
      ),
    );
  }
}
