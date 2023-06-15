import 'package:climb_it/main_app_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'firebase_options.dart';
import 'gyms/gym_nav.dart';
import 'profile_page.dart';
import 'settings/settings_page.dart';

void main() async {
  // Initialize widgets before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  Settings.init(cacheProvider: SharePreferenceCache());

  // Initialize Firebase using options from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.pink.withOpacity(0.75))
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.pink.withOpacity(0.75))
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const Home(),
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
      const Scaffold(
        appBar: MainAppBar(barTitle: 'Settings'),
        body: SettingsPage(),
      ),
    ];
  }

  _selectTab(int index) {
    setState(() {
      // Jump to the root route when pressing the BottomNavBarItem that is currently selected
      if (_selectedIndex == index) {
        gymNavigatorKey.currentState?.popUntil((route) => route.isFirst);
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
