import 'package:climb_it/gyms.dart';
import 'package:flutter/material.dart';

class GymNav extends StatelessWidget {
  const GymNav({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState != null && navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        }
        return false;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateInitialRoutes: (navigatorState, initialRoute) {
          return [
            MaterialPageRoute(
              builder: (context) => const GymPage()
            )
          ];
        },
      ),
    );
  }

}
