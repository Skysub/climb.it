import 'package:geolocator/geolocator.dart';

class LocationManager {
  static Future<Position?> getUserPos() async {
    if (await checkLocationPermission()) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }

  static Future<bool> checkLocationPermission() async {
    // Return false if the location service isn't enabled
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      return false;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    // If 'deniedForever' then we can't get the location
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    // If 'denied', ask for the permission again
    if (permission == LocationPermission.denied) {
      // If the permission is still 'denied
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return false;
      }
    }
    // Else we have 'whileInUse' or 'always', which means we can get the location
    return true;
  }
}
