import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Gym {
  final String name;

  Gym({required this.name});

  static Gym fromJSON(Map<dynamic, dynamic> json) {
    return Gym(name: json['name']);
  }
}

class GymPage extends StatefulWidget {
  const GymPage({super.key});

  @override
  State<GymPage> createState() => GymPageState();
}

class GymPageState extends State<GymPage> {
  late Future<List<Gym>> gymFuture;

  @override
  void initState() {
    super.initState();
    gymFuture = getData();
  }

  Future<void> updateGymList() async {
    setState(() {
      gymFuture = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: updateGymList,
      child: FutureBuilder(
          future: gymFuture,
          builder: (context, gymSnapshot) {
            if (gymSnapshot.hasData) {
              List<Gym> gyms = gymSnapshot.data!;
              return ListView.builder(
                  itemCount: gyms.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                        color: Color.lerp(Colors.pink, Colors.orange, index/gyms.length),
                        child: Center(child: Text(gyms[index].name)),
                      ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
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
