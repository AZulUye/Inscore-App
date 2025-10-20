import 'package:flutter/material.dart';
import 'package:inscore_app/features/leaderboard/presentation/leaderboard_screen.dart';
import 'package:inscore_app/screens/home_screen.dart';
import 'package:inscore_app/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LeaderboardScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // bottomNavigationBar: NavigationBar(
      //   labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      //   onDestinationSelected: _onItemTapped,
      //   selectedIndex: _selectedIndex,
      //   destinations: const <Widget>[
      //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      //     NavigationDestination(
      //       icon: Icon(Icons.bar_chart),
      //       label: 'Leaderboard',
      //     ),
      //     NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
      //   ],
      // ),

      // body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }
}
