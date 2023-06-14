import 'package:climb_it/gyms/route_item.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'gym.dart';

class ClimbingRoute {
  final String name;
  final String difficulty;

  ClimbingRoute({required this.name, required this.difficulty});

  static ClimbingRoute fromJSON(Map<dynamic, dynamic> json) {
    return ClimbingRoute(
        name: json['name'],
        difficulty: json['difficulty'] != null ? 'V${json['difficulty']}' : '');
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
        body: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: const Text("Ruter:", style: TextStyle(fontSize: 30))),
            Expanded(
              child: RefreshIndicator(
                onRefresh: updateRouteList,
                child: FutureBuilder(
                    future: routeFuture,
                    builder: (context, routeSnapshot) {
                      if (routeSnapshot.hasData) {
                        if (routeSnapshot.data!.isEmpty) {
                          return const Center(child: Text('This gym currently has no routes.'));
                        }
                        else {
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
                                      color: Color.lerp(
                                          Colors.pink,
                                          Colors.orange,
                                          index / routes.length)!,
                                    ),
                                  )),
                        );

                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            )
          ],
        ));
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