class Gym {
  final String key;
  final String name;
  final double latitude;
  final double longitude;
  double? distanceKm;

  Gym(
      {required this.key,
      required this.name,
      required this.latitude,
      required this.longitude});

  static Gym fromJSON(Map<dynamic, dynamic> json, String key) {
    return Gym(
        key: key,
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }
}
