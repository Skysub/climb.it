
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'icon_widget.dart';
import 'dark_mode_inherited_widget.dart';
import '../gyms/gym.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const keyPrimaryCenter = 'key-primaryCenter';
  bool? isDarkMode;
  List<Gym> gymList = []; //List to save gyms from firebase

  @override
  Widget build(BuildContext context) {
    final inheritedWidget = DarkModeInheritedWidget.of(context);
    if (inheritedWidget != null) {
      isDarkMode = inheritedWidget.isDarkMode;
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            SettingsGroup(
              title: 'GENERAL',
              children: <Widget>[
                const SizedBox(height: 30),
                buildChoosePrimaryCenter(),
                const SizedBox(height: 50),
                buildDarkMode(),
                const SizedBox(height: 50),
                buildResetData(),
                const SizedBox(height: 50),
                buildHelpAndSupport(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChoosePrimaryCenter() => DropDownSettingsTile(
        settingKey: keyPrimaryCenter,
        title: 'Choose primary center',
        selected: 1,
        values: const <int, String>{
          1: 'Boulders',
          2: 'Beta',
          3: 'Boulders Valby',
        },
        leading: const IconWidget(
            icon: Icons.add_location_sharp, color: Colors.pink),
        onChange: (primaryCenter) {/*NOOb*/},
      );

  Widget buildDarkMode() {
    if (isDarkMode == null) {
      return const SizedBox
          .shrink(); // Hidden until the value of 'isDarkMode' is changed
    }
    return SwitchListTile(
      value: isDarkMode!,
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
        subtitle: '',
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
          content: const Text('Are you sure you want to reset your data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // close the dialog 'false' (close)
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // close the dialog 'true' (accept)
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
    if (resetConfirmed == true) {
      resetData();
    }
  }

  void resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    Phoenix.rebirth(context);
  }

  Widget buildHelpAndSupport() => SimpleSettingsTile(
        title: 'Help/Support',
        subtitle: '',
        leading: const IconWidget(
            icon: Icons.headset_mic_outlined, color: Colors.pink),
        onTap: () {
          _showHelpAndSupport();
        },
      );

  void _showHelpAndSupport() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help and Supoort'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('TLF'),
              Text('Mail'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
