import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/session_data_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionData = Provider.of<UserSessionData>(context);

    return ListTile(
      title: Text('Dark Mode'),
      leading: Icon(Icons.brightness_4),
      trailing: Switch(
        value: sessionData.isDarkTheme,
        onChanged: (bool value) {
          sessionData.toggleTheme();
        },
      ),
    );
  }
}
