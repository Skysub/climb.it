import 'package:climb_it/main_app_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'gym.dart';
import 'gym_item.dart';
import 'gym_overview.dart';

class GymList extends StatefulWidget {
  const GymList({super.key});

  @override
  State<GymList> createState() => GymListState();
}

class GymListState extends State<GymList> {
  late Future<List<Gym>> gymFuture;

  @override
  void initState() {
    super.initState();
    gymFuture = getGymList();
  }

  Future<void> updateGymList() async {
    setState(() {
      gymFuture = getGymList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(barTitle: 'Gyms'),
      body: RefreshIndicator(
        onRefresh: updateGymList,
        child: FutureBuilder(
            future: gymFuture,
            builder: (context, gymSnapshot) {
              if (gymSnapshot.hasData) {
                List<Gym> gyms = gymSnapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                      itemCount: gyms.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GymOverview(gym: gyms[index])))
                            },
                            child: GymItem(
                              gym: gyms[index],
                              color: Color.lerp(Colors.pink, Colors.orange,
                                  index / gyms.length)!,
                            ),
                          )),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Future<List<Gym>> getGymList() async {
    var data = await FirebaseDatabase.instance.ref().child('gyms').once();
    var gymList = data.snapshot.children
        .map((e) => Gym.fromJSON(e.value as Map, e.key ?? ''))
        .toList();

    // If we have/get location permission, calculate the distance to each gym
    if (await checkLocationPermission()) {
      Position pos = await Geolocator.getCurrentPosition();
      for (Gym g in gymList) {
        g.distanceKm = 0.001 * Geolocator.distanceBetween(g.latitude, g.longitude, pos.latitude, pos.longitude);
      }
      // Sort the list by distance
      gymList.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
    }

    return gymList;
  }

  Future<bool> checkLocationPermission() async {
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
      if (permission != LocationPermission.always || permission != LocationPermission.whileInUse) {
        return false;
      }
    }
    // Else we have 'whileInUse' or 'always', which means we can get the location
    return true;
  }
}
