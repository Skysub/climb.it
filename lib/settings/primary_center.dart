import 'package:climb_it/firebase/firebase_manager.dart';
import 'package:climb_it/gyms/gym.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'icon_widget.dart';

class PrimaryCenterSettings extends StatefulWidget {
  const PrimaryCenterSettings({Key? key}) : super(key: key);

  @override
  createState() => _PrimaryCenterSettingsState();
}

class _PrimaryCenterSettingsState extends State<PrimaryCenterSettings> {
  static const keyPrimaryCenter = 'key-primaryCenter';
  late Future<List<Gym>> gymFuture;
  List<Gym> gymList = []; // List to save gyms from Firebase

  @override
  void initState() {
    super.initState();
    gymFuture = FirebaseManager.geGymList(calculateDistances: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gym>>(
      future: gymFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          gymList = snapshot.data!;
          return DropDownSettingsTile(
            settingKey: keyPrimaryCenter,
            title: 'Primary Gym',
            selected: 0,
            values: ['None', ...gymList.map((e) => e.name).toList()].asMap(),
            leading: const IconWidget(
              icon: Icons.location_on,
              color: Colors.pink,
            ),
            onChange: (primaryCenter) async {
              // If other than 'None' is selected, save the key of the primary gym
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (primaryCenter > 0) {
                prefs.setString(
                    'primary_gym_key', gymList[primaryCenter - 1].key);
              }
              else {
                prefs.remove('primary_gym_key');
              }
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading gyms');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
