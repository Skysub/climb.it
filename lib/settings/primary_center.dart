import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../gyms/gym.dart';
import '../gyms/gym_list.dart';
import 'icon_widget.dart';

class PrimaryCenterSettings extends StatefulWidget {
  const PrimaryCenterSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrimaryCenterSettingsState createState() => _PrimaryCenterSettingsState();
}

class _PrimaryCenterSettingsState extends State<PrimaryCenterSettings> {
  static const keyPrimaryCenter = 'key-primaryCenter';
  List<Gym> gymList = []; //List to save gyms from firebase

  @override
  Widget build(BuildContext context) {
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

  Future<List<Gym>> _getGymList() async {
    GymListState gymListState = GymListState();
    gymListState.initState();
    return gymListState.getGymList();
  }
}
