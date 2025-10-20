import 'package:flutter/material.dart';
import 'package:inscore_app/features/leaderboard/presentation/leaderboard_provider.dart';
import 'package:inscore_app/features/leaderboard/presentation/widgets/leaderboard_body.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LeaderboardProvider(),
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
                Tab(text: "Daily"),
                Tab(text: "Weekly"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              LeaderboardBody(period: "Daily"),
              LeaderboardBody(period: "Weekly"),
            ],
          ),
        ),
      ),
    );
  }
}
