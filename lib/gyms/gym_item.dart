import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                Row(
                  children: [
                    Text(gym.name,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    if (gym.isFavourite)
                      const Icon(Icons.favorite, color: Colors.white),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      String query = Uri.decodeComponent(gym.name);
                      await launchUrl(
                          Uri.parse(
                              'https://www.google.com/maps/search/?api=1&query=$query'),
                          mode: LaunchMode.externalApplication);
                    } finally {}
                  },
                  child: Column(children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    if (gym.distanceKm != null) const SizedBox(height: 3),
                    if (gym.distanceKm != null)
                      Text("${gym.distanceKm!.toStringAsFixed(1)} km",
                          style: const TextStyle(color: Colors.white)),
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}
