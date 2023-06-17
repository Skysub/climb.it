import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'icon_widget.dart';
import 'dark_mode_inherited_widget.dart';
import 'primary_center.dart';
import 'help_and_support.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;


  @override
  Widget build(BuildContext context) {
    final inheritedWidget = DarkModeInheritedWidget.of(context);
    if (inheritedWidget != null) {
      isDarkMode = inheritedWidget.isDarkMode;
    }
    return Scaffold(
      appBar: const MainAppBar(barTitle: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            SettingsGroup(
              title: 'GENERAL',
              children: <Widget>[
                const PrimaryCenterSettings(),
                const SizedBox(height: 15),
                buildDarkMode(),
                const SizedBox(height: 12),
                buildResetData(),
                const SizedBox(height: 15),
                const HelpAndSupportSettings(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDarkMode() {
    return SwitchListTile(
      value: isDarkMode,
      onChanged: (value) => toggleDarkMode(value),
      title: const Text('Dark Mode'),
      secondary:
          const IconWidget(icon: Icons.dark_mode_outlined, color: Colors.pink),
    );
  }

  void toggleDarkMode(bool value) {
    final inheritedWidget = DarkModeInheritedWidget.of(context);
    if (inheritedWidget != null) {
      inheritedWidget.toggleDarkMode(value);
      setState(() {
        isDarkMode = value;
      });
    }
  }

  Widget buildResetData() => SimpleSettingsTile(
        title: 'Reset Data',
        leading:
            const IconWidget(icon: Icons.refresh_outlined, color: Colors.pink),
        onTap: () {
          _showResetConfirmationDialog(); // Method to show confirmationsdialog
        },
      );

  void _showResetConfirmationDialog() async {
    bool resetConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Data'),
          content: const Text(
              'Are you sure you want to reset your data?\n\nAll route progression and profile data will be lost!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
    if (resetConfirmed == true) {
      _resetData();
    }
  }

  void _resetData() {
    // Clear all preferences and reload the app using Phoenix
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
    Phoenix.rebirth(context);
  }
}
