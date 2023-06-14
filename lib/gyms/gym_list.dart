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
    List data = await Future.wait([
      FirebaseDatabase.instance.ref().child('gyms').once(),
      getCoordiantes()
    ]);
    DatabaseEvent d0 = data[0];
    return gymLocationSort(
        d0.snapshot.children
            .map((e) => Gym.fromJSON(e.value as Map, e.key ?? ''))
            .toList(),
        data[1]);
  }

  List<Gym> gymLocationSort(List<Gym> gyms, Map<String, List<double>> coords) {
    if (coords.isEmpty) {
      return gyms;
    }
    //Sets the distance for each gym
    for (Gym x in gyms) {
      x.distance = 0.001 *
          Geolocator.distanceBetween(coords['userCoords']![0],
              coords['userCoords']![1], coords[x.key]![0], coords[x.key]![1]);
    }

    gyms.sort((g1, g2) => g1.distance.compareTo(g2.distance));

    return gyms;
  }

  Future<Map<String, List<double>>> getCoordiantes() async {
    bool canGetLocation = await checkLocationPermission();
    if (!canGetLocation) {
      return {};
    }

    //Now we get the locations
    List data = await Future.wait([
      Geolocator.getCurrentPosition(),
      FirebaseDatabase.instance.ref().child('gym_coordinates').once()
    ]);
    DatabaseEvent gymData = data[1];
    var coords = Map<String, List<double>>.fromEntries(gymData.snapshot.children
        .map((e) => MapEntry<String, List<double>>(e.key!, [
              e.children.first.value as double,
              e.children.last.value as double
            ])));
    coords.putIfAbsent('userCoords',
        () => [data[0].latitude as double, data[0].longitude as double]);
    return coords;
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
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // Else we have 'whileInUse' or 'always', which means we can get the location
    return true;
  }
}
