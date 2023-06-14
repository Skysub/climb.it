import 'package:climb_it/gyms/gym_overview.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';

class RoutePage extends StatelessWidget {
  const RoutePage({super.key, required this.route});

  final ClimbingRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(barTitle: route.name),
        body: Center(child: Text(route.name)));
  }
}
