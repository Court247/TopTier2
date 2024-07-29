import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: const Text(
          'Settings',
          style: const TextStyle(fontSize: 30, fontFamily: 'Horizon'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SafeArea(
        child: Settings_Page(),
      ),
    ));
  }
}

class Settings_Page extends StatefulWidget {
  const Settings_Page({
    super.key,
  });

  @override
  State<Settings_Page> createState() => _Settings_Page();
}

class _Settings_Page extends State<Settings_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // SwitchListTile(
          //   title: const Text('Dark Theme'),
          //   value: _darkThemeEnabled,
          //   onChanged: (bool value) {
          //     setState(() {
          //       _darkThemeEnabled = value;
          //     });
          //     // Implement theme change logic
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.account_circle_sharp),
            title: Text('Account Settings'),
            onTap: () {
              // Navigate to language selection screen
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy'),
            onTap: () {
              // Navigate to privacy settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Send Feedback'),
            onTap: () {
              // Implement feedback logic
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
