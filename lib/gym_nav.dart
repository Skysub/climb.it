import 'package:climb_it/gyms.dart';
import 'package:flutter/material.dart';

class GymNav extends StatelessWidget {
  const GymNav({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateInitialRoutes: (navigatorState, initialRoute) {
        return [
          MaterialPageRoute(
            builder: (context) => const GymPage()
          )
        ];
      },
    );
  }

}
