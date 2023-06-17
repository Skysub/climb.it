import 'package:climb_it/gyms/gym.dart';
import 'package:climb_it/location/location_manager.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseManager {
  static Future<List<Gym>> geGymList({required bool calculateDistances}) async {
    // Calling both async functions in parrallel
    var futures = await Future.wait([
      FirebaseDatabase.instance.ref().child('gyms').once(),
      // Only load location if we want to calculate distance
      if (calculateDistances) LocationManager.getUserPos()
    ]);

    //Convincing the compiler that the objects have type
    DatabaseEvent data = futures[0] as DatabaseEvent;
    Position? pos = calculateDistances ? futures[1] as Position? : null;

    var gymList = data.snapshot.children
        .map((e) => Gym.fromJSON(e.value as Map, e.key ?? ''))
        .toList();

    // If we have/get location permission, calculate the distance to each gym
    if (pos != null) {
      for (Gym g in gymList) {
        g.distanceKm = 0.001 *
            Geolocator.distanceBetween(
                g.latitude, g.longitude, pos.latitude, pos.longitude);
      }
      // Sort the list by distance
      gymList.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
    }

    // Load whether any gyms are selected as favourite
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? primaryGymKey = prefs.getString('primary_gym_key');
    if (primaryGymKey != null) {
      gymList.firstWhereOrNull((gym) => gym.key == primaryGymKey)?.isFavourite =
          true;
      // Sort list so favourite is first
      gymList.sort((a, b) =>
          (a.isFavourite == b.isFavourite ? 0 : (a.isFavourite ? -1 : 1)));
    }

    return gymList;
  }
}
