import 'package:flutter/material.dart';

import 'gym_overview.dart';

class RouteItem extends StatelessWidget {
  const RouteItem(
      {super.key, required this.climbingRoute, required this.color});

  final ClimbingRoute climbingRoute;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (climbingRoute.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  climbingRoute.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: -5,
              children: [
                for (String tag in climbingRoute.tags)
                  Chip(label: Text(tag, style: const TextStyle(color: Colors.white)), elevation: 2, backgroundColor: climbingRoute.color),
              ]),
            const SizedBox(height: 5),
            Text('${climbingRoute.name} - ${climbingRoute.difficulty}'),
          ],
        ),
      ),
    );
  }
}
