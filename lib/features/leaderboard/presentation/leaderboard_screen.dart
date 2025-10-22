import 'package:flutter/material.dart';
import 'package:inscore_app/features/leaderboard/presentation/leaderboard_body.dart';
import '../../../shared/custom_text.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // var tabFontColor = theme.colorScheme.onPrimary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.arrow_back_ios_new),
          // ),
          backgroundColor: theme.colorScheme.surface,
          title: CustomText(
            "Leaderboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: CustomText("Daily", style: TextStyle(fontSize: 14))),

              Tab(child: CustomText("Weekly", style: TextStyle(fontSize: 14))),
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
    );
  }
}
