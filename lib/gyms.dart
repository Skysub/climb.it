import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Gym {
  final String name;

  Gym({required this.name});

  static Gym fromJSON(Map<dynamic, dynamic> json) {
    return Gym(name: json['name']);
  }
}

class GymPage extends StatelessWidget {
  const GymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, gymSnapshot) {
          if (gymSnapshot.hasData) {
            List<Gym> gyms = gymSnapshot.data!;
            return ListView.builder(
                itemCount: gyms.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    Center(child: Text(gyms[index].name)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<List<Gym>> getData() async {
    //TODO Remove delay. Used to visualize loading
    await Future.delayed(const Duration(milliseconds: 500));
    var data = await FirebaseDatabase.instance.ref().child('locations').once();
    return data.snapshot.children
        .map((e) => Gym.fromJSON(e.value as Map))
        .toList();
  }
}
