import 'package:flutter/material.dart';
import 'package:mini_3/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '/screens/trending_media_screen.dart';
import 'screens/search_results_screen.dart';
import 'screens/user_profile_screen.dart';
import 'utils/theme.dart';
import 'provider/session_data_provider.dart'; // Import your UserSessionData class

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          UserSessionData(), // Initialize your UserSessionData provider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    TrendingMediaScreen(),
    UserProfileScreen(),
    SearchResultScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: appTheme,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: 'TV Shows',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2),
              label: 'My Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
