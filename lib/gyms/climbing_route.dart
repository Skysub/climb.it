import 'package:flutter/material.dart';

import 'hint.dart';

class ClimbingRoute {
  final String key;
  final String name;
  final int difficulty;
  final String imageUrl;
  final List<String> tags;
  final Color color;
  final List<Hint> hints;
  bool isCompleted;

  ClimbingRoute(
      {required this.key,
      required this.name,
      required this.difficulty,
      required this.imageUrl,
      required this.tags,
      required this.color,
      required this.hints,
      required this.isCompleted});

  static ClimbingRoute fromJSON(
      Map<dynamic, dynamic> json, Map<dynamic, dynamic>? hintsJSON, String key) {
    return ClimbingRoute(
        key: key,
        name: json['name'],
        difficulty: json['difficulty'] ?? 0,
        imageUrl: json['img_url'] ??
            'https://firebasestorage.googleapis.com/v0/b/klatre-app1.appspot.com/o/example_images%2Fboulders_example.jpg?alt=media',
        tags: json['tags'] != null ? json['tags'].split(';') : [],
        color: getColor(json['color']),
        isCompleted: false,
        hints: hintsJSON != null
            ? List.generate(hintsJSON.length,
                (index) => Hint.fromJSON(hintsJSON['hint${index + 1}']))
            : []);
  }

  //TODO Decice which colors to use. Yellow is too bright
  static Color getColor(String? json) {
    switch (json) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow[700]!;
      case 'orange':
        return Colors.orange;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'pink':
      default:
        return Colors.pink;
    }
  }
}