import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'icon_widget.dart';

class ResetDataSettings extends StatelessWidget {
  const ResetDataSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Reset Data',
      leading: const IconWidget(icon: Icons.refresh_outlined, color: Colors.pink),
      onTap: () {
        _showResetConfirmationDialog(context); // Method to show confirmation dialog
      },
    );
  }

  void _showResetConfirmationDialog(BuildContext context) async {
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
      // ignore: use_build_context_synchronously
      _resetData(context);
    }
  }

  void _resetData(BuildContext context) {
    // Clear all preferences and reload the app using Phoenix
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
    Phoenix.rebirth(context);
  }
}