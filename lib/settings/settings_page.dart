import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';

import 'icon_widget.dart';
import 'dark_mode_inherited_widget.dart';
import '../gyms/gym.dart';
import '../gyms/gym_list.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const keyPrimaryCenter = 'key-primaryCenter';
  bool isDarkMode = false;
  List<Gym> gymList = []; //List to save gyms from firebase

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
                buildChoosePrimaryCenter(),
                const SizedBox(height: 15),
                buildDarkMode(),
                const SizedBox(height: 12),
                buildResetData(),
                const SizedBox(height: 15),
                buildHelpAndSupport(),
              ],
            ),
          ],
        ),
      ),
    );
  }

   Widget buildChoosePrimaryCenter() {
    return FutureBuilder<List<Gym>>(
      future: _getGymList(), // get gymList from firebase
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Gym> gyms = snapshot.data!;
          return DropDownSettingsTile(
            settingKey: keyPrimaryCenter,
            title: 'Choose primary center',
            selected: 1,
            values: Map.fromEntries(gyms.asMap().entries.map(
                  (entry) => MapEntry(entry.key + 1, entry.value.name),
                )),
            leading: const IconWidget(
              icon: Icons.add_location_sharp,
              color: Colors.pink,
            ),
            onChange: (primaryCenter) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt(keyPrimaryCenter, primaryCenter);
            },
          );
        } else if (snapshot.hasError) {
          return const Text(
              'Error loading gyms'); 
        } else {
          return const CircularProgressIndicator(); // show indicator while loading gymlist
        }
      },
    );
  }

  Future<List<Gym>> _getGymList() async {
    GymListState gymListState = GymListState();
     gymListState.initState();
    return gymListState.getGymList();
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

  Widget buildHelpAndSupport() => SimpleSettingsTile(
      title: 'Help/Support',
      subtitle: '',
      leading: const IconWidget(
          icon: Icons.headset_mic_outlined, color: Colors.pink),
      onTap: () {
        _showHelpAndSupportDialog();
      },
    );

void _showHelpAndSupportDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Help and Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _launchPhone('+45 12345 5678'); 
              },
              child: const Text('Phone: +45 1234 5678'), 
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                _launchEmail('support@example.com'); 
              },
              child: const Text('Email: support@example.com'), 
            ),
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

void _launchPhone(String phoneNumber) async {
  final phoneUrl = 'tel:$phoneNumber';
  if (await canLaunchUrl(phoneUrl as Uri)) {
    await launchUrl(Uri.parse(phoneUrl));
  } else {
    throw 'Could not launch $phoneUrl';
  }
}

void _launchEmail(String emailAddress) async {
  final emailUrl = 'mailto:$emailAddress';
  if (await canLaunchUrl(emailUrl as Uri)) {
    await launchUrl(Uri.parse(emailUrl));
  } else {
    throw 'Could not launch $emailUrl';
  }
}
}
