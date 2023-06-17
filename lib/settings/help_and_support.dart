import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'icon_widget.dart';

class HelpAndSupportSettings extends StatelessWidget {
  const HelpAndSupportSettings({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Help/Support',
      subtitle: '',
      leading: const IconWidget(
          icon: Icons.headset_mic_outlined, color: Colors.pink),
      onTap: () {
        _showHelpAndSupportDialog(context);
      },
    );
  }

  void _showHelpAndSupportDialog(BuildContext context) {
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
}
