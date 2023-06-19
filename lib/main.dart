import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'firebase_options.dart';
import 'gyms/gym_nav.dart';
import 'profile_page.dart';
import 'settings/settings_page.dart';
import 'settings/dark_mode_inherited_widget.dart';

void main() async {
  // Initialize widgets before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  Settings.init(cacheProvider: SharePreferenceCache());

  // Initialize Firebase using options from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences _prefs;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    await _prefs.setBool('isDarkMode', value);
    setState(() {
      isDarkMode = value;
    });
  }

  void toggleDarkMode(bool value) {
    _saveDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'climb.it',
      theme: ThemeData(
          brightness: Brightness.light,
          scrollbarTheme: ScrollbarThemeData(
              thumbColor:
                  MaterialStateProperty.all(Colors.pink.withOpacity(0.75)))),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(
            thumbColor:
                MaterialStateProperty.all(Colors.pink.withOpacity(0.75))),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: DarkModeInheritedWidget(
        isDarkMode: isDarkMode,
        toggleDarkMode: toggleDarkMode,
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  GlobalKey<NavigatorState> gymNavigatorKey = GlobalKey();

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      GymNav(navigatorKey: gymNavigatorKey),
      ProfilePage(),
      const SettingsPage()
    ];
  }

  _selectTab(int index) {
    setState(() {
      // Jump to the root route when pressing the BottomNavBarItem that is currently selected
      if (_selectedIndex == index && _selectedIndex == 0) {
        gymNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      }
      if (index == 1) {
        pages[1] = ProfilePage();
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Routes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.lerp(
            Colors.pink, Colors.orange, _selectedIndex / pages.length),
        onTap: _selectTab,
      ),
    );
  }
}
