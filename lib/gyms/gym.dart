class Gym {
  final String key;
  final String name;

  Gym({required this.key, required this.name});

  static Gym fromJSON(Map<dynamic, dynamic> json, String key) {
    return Gym(key: key, name: json['name']);
  }
}