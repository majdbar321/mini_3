import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/session_data_provider.dart'; // Assuming this provider handles user settings

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionDataProvider = Provider.of<UserSessionData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Theme'),
            value: sessionDataProvider.isDarkTheme,
            onChanged: (bool value) {
              sessionDataProvider.toggleTheme();
            },
          ),
          // Additional settings options...
        ],
      ),
    );
  }
}
