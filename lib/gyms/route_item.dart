import 'package:flutter/material.dart';

import 'gym_overview.dart';

class RouteItem extends StatelessWidget {
  const RouteItem(
      {super.key, required this.climbingRoute, required this.color});

  final ClimbingRoute climbingRoute;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color),
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
            alignment: Alignment.centerLeft,
            child:
                Text(climbingRoute.name, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}
