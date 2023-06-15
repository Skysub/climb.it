import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  const Tags({super.key, required this.tags, required this.color});

  final List<String> tags;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: -5, children: [
      for (String tag in tags)
        Chip(
            label: Text(tag, style: const TextStyle(color: Colors.white)),
            elevation: 2,
            backgroundColor: color),
    ]);
  }
}
