import 'package:climb_it/firebase/firebase_manager.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';

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
    gymFuture = FirebaseManager.geGymList(calculateDistances: true);
  }

  Future<void> _updateGymList() async {
    setState(() {
      gymFuture = FirebaseManager.geGymList(calculateDistances: true);
    });
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
              if (gymSnapshot.hasData && gymSnapshot.connectionState == ConnectionState.done) {
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
}
