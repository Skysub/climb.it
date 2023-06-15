import 'package:flutter/material.dart';

class DarkModeInheritedWidget extends InheritedWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  const DarkModeInheritedWidget({super.key, 
    required this.isDarkMode,
    required this.toggleDarkMode,
    required Widget child,
  }) : super(child: child);

  static DarkModeInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DarkModeInheritedWidget>();
  }

  @override
  bool updateShouldNotify(DarkModeInheritedWidget oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}

