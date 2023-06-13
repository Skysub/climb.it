import 'package:climb_it/gyms/route_item.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'gym.dart';

class ClimbingRoute {
  final String name;

  ClimbingRoute({required this.name});

  static ClimbingRoute fromJSON(Map<dynamic, dynamic> json) {
    return ClimbingRoute(name: json['name']);
  }
}

class GymOverview extends StatefulWidget {
  final Gym gym;
  const GymOverview({super.key, required this.gym});

  @override
  State<GymOverview> createState() => GymOverviewState();
}

class GymOverviewState extends State<GymOverview> {
  late Future<List<ClimbingRoute>> routeFuture;

  @override
  void initState() {
    super.initState();
    routeFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(barTitle: widget.gym.name),
      body: RefreshIndicator(
        onRefresh: updateRouteList,
        child: FutureBuilder(
            future: routeFuture,
            builder: (context, routeSnapshot) {
              if (routeSnapshot.hasData) {
                List<ClimbingRoute> routes = routeSnapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                      itemCount: routes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () => {},
                            child: RouteItem(
                              climbingRoute: routes[index],
                              color: Color.lerp(Colors.pink, Colors.orange,
                                  index / routes.length)!,
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

  Future<void> updateRouteList() async {
    setState(() {
      routeFuture = getData();
    });
  }

  Future<List<ClimbingRoute>> getData() async {
    var data = await FirebaseDatabase.instance
        .ref()
        .child('routes')
        .child(widget.gym.key)
        .once();
    return data.snapshot.children
        .map((e) => ClimbingRoute.fromJSON(e.value as Map))
        .toList();
  }
}
