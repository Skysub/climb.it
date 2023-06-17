import 'package:flutter/material.dart';
import 'icon_widget.dart';
import 'dark_mode_inherited_widget.dart';

class DarkModeSettings extends StatefulWidget {
  const DarkModeSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DarkModeSettingsState createState() => _DarkModeSettingsState();
}

class _DarkModeSettingsState extends State<DarkModeSettings> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: isDarkMode,
      onChanged: toggleDarkMode,
      title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w500)),
      secondary:
          const IconWidget(icon: Icons.dark_mode_outlined, color: Colors.pink),
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inheritedWidget = DarkModeInheritedWidget.of(context);
    if (inheritedWidget != null) {
      isDarkMode = inheritedWidget.isDarkMode;
    }
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
}
