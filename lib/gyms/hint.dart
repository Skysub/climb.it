class Hint {
  final String name;
  final String data;
  final HintType type;

  Hint({required this.name, required this.data, required this.type});

  static Hint fromJSON(Map<dynamic, dynamic> json) {
    return Hint(
      name: json['name'] ?? 'Hint',
      data: json['data'],
      type: HintType.values.byName(json['type']),
    );
  }
}

enum HintType { image, text, video }