import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'primary_center.dart';
import 'dark_mode.dart';
import 'reset_data.dart';
import 'help_and_support.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(barTitle: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            SettingsGroup(
              title: 'GENERAL',
              children: const <Widget>[
                PrimaryCenterSettings(),
                SizedBox(height: 15),
                DarkModeSettings(),
                SizedBox(height: 12),
                ResetDataSettings(),
                SizedBox(height: 15),
                HelpAndSupportSettings(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
