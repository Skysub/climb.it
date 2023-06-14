import 'package:flutter/material.dart';

import 'gym.dart';

class GymItem extends StatelessWidget {
  const GymItem({super.key, required this.gym, required this.color});

  final Gym gym;
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
            child: Text(
                "${gym.name} _dist: ${gym.distance.toStringAsFixed(1)} km",
                style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}
