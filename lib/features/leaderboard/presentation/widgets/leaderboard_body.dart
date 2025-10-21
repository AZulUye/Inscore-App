import 'package:flutter/material.dart';
import 'package:inscore_app/core/enums.dart';
import 'package:inscore_app/features/leaderboard/presentation/leaderboard_provider.dart';
import 'package:provider/provider.dart';

class LeaderboardBody extends StatefulWidget {
  const LeaderboardBody({super.key, required this.period});

  final String period;

  @override
  State<LeaderboardBody> createState() => _LeaderboardBodyState();
}

class _LeaderboardBodyState extends State<LeaderboardBody> {
  @override
  void initState() {
    Future.microtask(() {
      if (mounted) {
        context.read<LeaderboardProvider>().fetchLeaderboard(widget.period);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaderboardProvider>(
      builder: (context, model, _) {
        return switch (model.state) {
          ViewState.loading => const Center(child: CircularProgressIndicator()),
          ViewState.error => Center(child: Text(model.errorMessage)),
          ViewState.success => ListView.builder(
            itemCount: model.userScores.length,
            itemBuilder: (context, index) {
              final data = model.userScores[index];
              final num = index + 1;

              return ListTile(
                onTap: () {},
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: (num >= 1 && num <= 3)
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                )
                              : null,
                        ),

                        Text(num.toString()),
                      ],
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data.avatarUrl!),
                    ),
                  ],
                ),
                title: Text(data.name, overflow: TextOverflow.ellipsis),
                trailing: Text(
                  data.score.toStringAsFixed(2),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),

          _ => SizedBox.shrink(),
        };
      },
    );
  }
}
