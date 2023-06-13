import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:climb_it/gyms.dart';

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
    return RefreshIndicator(
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
                            route: routes[index],
                            color: Color.lerp(Colors.pink, Colors.orange,
                                index / routes.length)!,
                          ),
                        )),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> updateRouteList() async {
    setState(() {
      routeFuture = getData();
    });
  }

  Future<List<ClimbingRoute>> getData() async {
    //TODO Remove delay. Used to visualize loading
    await Future.delayed(const Duration(milliseconds: 500));
    var data = await FirebaseDatabase.instance
        .ref()
        .child('routes/${widget.gym.name}')
        .once();
    return data.snapshot.children
        .map((e) => ClimbingRoute.fromJSON(e.value as Map))
        .toList();
  }
}

class RouteItem extends StatelessWidget {
  const RouteItem({super.key, required this.route, required this.color});

  final ClimbingRoute route;
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
            child: Text(route.name, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}
