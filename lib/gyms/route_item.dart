import 'package:cached_network_image/cached_network_image.dart';
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
      elevation: 4,
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
                child: CachedNetworkImage(
                  imageUrl: climbingRoute.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            const SizedBox(height: 5),
            Wrap(spacing: 8, runSpacing: -5, children: [
              for (String tag in climbingRoute.tags)
                Chip(
                    label:
                        Text(tag, style: const TextStyle(color: Colors.white)),
                    elevation: 2,
                    backgroundColor: climbingRoute.color),
            ]),
            const SizedBox(height: 5),
            Text('${climbingRoute.name} - ${climbingRoute.difficulty}'),
          ],
        ),
      ),
    );
  }
}
