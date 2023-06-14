import 'package:flutter/material.dart';

import 'gym.dart';

class GymItem extends StatelessWidget {
  const GymItem({super.key, required this.gym, required this.color});

  final Gym gym;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(gym.name, style: const TextStyle(fontSize: 24)),
                if (gym.distanceKm != null)
                Column(
                  children: [
                  const Icon(Icons.location_on),
                  const SizedBox(height: 3),
                  Text("${gym.distanceKm!.toStringAsFixed(1)} km"),
                ]),
              ],
            )),
      ),
    );
  }
}
