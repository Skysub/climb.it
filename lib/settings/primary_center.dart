import 'package:climb_it/firebase/firebase_manager.dart';
import 'package:climb_it/gyms/gym.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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
              // Save the selected primary center
              // You can add your implementation here
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
