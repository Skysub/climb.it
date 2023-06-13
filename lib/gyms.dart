import 'package:climb_it/gym_overview.dart';
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

class GymItem extends StatelessWidget {
  const GymItem({super.key, required this.gym, required this.color});

  final Gym gym;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color),
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(gym.name, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}
