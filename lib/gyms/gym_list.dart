import 'package:climb_it/location/location_manager.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(barTitle: 'Gyms'),
      body: RefreshIndicator(
        onRefresh: _updateGymList,
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

  Future<void> _updateGymList() async {
    setState(() {
      gymFuture = getGymList();
    });
  }

  Future<List<Gym>> getGymList() async {
    //Calling both async functions in parrallel
    var futures = await Future.wait([
      FirebaseDatabase.instance.ref().child('gyms').once(),
      LocationManager.getUserPos()
    ]);

    //Convincing the compiler that the objects have type
    DatabaseEvent data = futures[0] as DatabaseEvent;
    Position? pos = futures[1] as Position?;

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
    return gymList;
  }
}
