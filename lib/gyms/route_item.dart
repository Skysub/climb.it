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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 24),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(climbingRoute.name,
                        style: const TextStyle(fontSize: 24))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'V69',
                      style: TextStyle(fontSize: 14),
                    ),
                  ))
                ],
              ),
            )
          ],
        ));
  }
}
