import 'package:climb_it/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'gyms/gym_nav.dart';

void main() async {
  // Initialize widgets before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();

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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //home: const Home(),

      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
      },
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

  List<Color> bottomColors = [0.0, 0.5, 1.0]
      .map((e) => Color.lerp(Colors.pink, Colors.orange, e)!)
      .toList();

  @override
  void initState() {
    super.initState();
    pages = [
      GymNav(navigatorKey: gymNavigatorKey),
      ProfilePage(),
      const Text('Settings Page')
    ];
  }

  _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('climb.it'),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.pink, Colors.orange]))),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Routes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: bottomColors[_selectedIndex],
        onTap: _selectTab,
      ),
    );
  }
}
