import 'package:climb_it/gyms/route.dart';
import 'package:climb_it/gyms/route_item.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'gym.dart';

class ClimbingRoute {
  final String name;
  final String difficulty;
  final String imageUrl;
  final List<String> tags;
  final Color color;

  ClimbingRoute(
      {required this.name,
      required this.difficulty,
      required this.imageUrl,
      required this.tags,
      required this.color});

  static ClimbingRoute fromJSON(Map<dynamic, dynamic> json) {
    return ClimbingRoute(
        name: json['name'],
        difficulty: json['difficulty'] != null ? 'V${json['difficulty']}' : '',
        imageUrl: json['img_url'] ??
            'https://firebasestorage.googleapis.com/v0/b/klatre-app1.appspot.com/o/example_images%2Fboulders_example.jpg?alt=media',
        tags: json['tags'] != null ? json['tags'].split(';') : [],
        color: getColor(json['color']));
  }

  static Color getColor(String? json) {
    switch (json) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      default:
        return Colors.pink;
    }
  }
}

class GymOverview extends StatefulWidget {
  final Gym gym;
  const GymOverview({super.key, required this.gym});

  @override
  State<GymOverview> createState() => GymOverviewState();
}

enum RouteSortMode { grade, name }

class GymOverviewState extends State<GymOverview> {
  late Future<List<ClimbingRoute>> routeFuture;
  late List<ClimbingRoute> routes;

  //TODO Handle sorting more general
  RouteSortMode sortMode = RouteSortMode.grade;
  bool sortDescending = false;

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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 5, children: [
                //TODO Extract SortChip() widget
                ActionChip(
                    backgroundColor: sortMode == RouteSortMode.grade ? Colors.pink : null,
                    avatar: sortMode == RouteSortMode.grade
                        ? Icon(sortDescending
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded)
                        : null,
                    label: const Text('Grade'),
                    onPressed: () => {
                          sortDescending = sortMode == RouteSortMode.grade
                              ? !sortDescending
                              : sortDescending,
                          sortMode = RouteSortMode.grade,
                          sortByDifficulty()
                        }),
                ActionChip(
                    backgroundColor: sortMode == RouteSortMode.name ? Colors.pink : null,
                    avatar: sortMode == RouteSortMode.name
                        ? Icon(sortDescending
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded)
                        : null,
                    label: const Text('Name'),
                    onPressed: () => {
                          sortDescending = sortMode == RouteSortMode.name
                              ? !sortDescending
                              : sortDescending,
                          sortMode = RouteSortMode.name,
                          sortByName()
                        }),
              ]),
              const SizedBox(height: 10),
              Flexible(
                child: FutureBuilder(
                    future: routeFuture,
                    builder: (context, routeSnapshot) {
                      if (routeSnapshot.hasData) {
                        routes = routeSnapshot.data!;
                        if (routeSnapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('This gym currently has no routes.'));
                        } else {
                          return ListView.separated(
                              itemCount: routes.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 15),
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RoutePage(
                                                  route: routes[index])))
                                    },
                                    child: RouteItem(
                                      climbingRoute: routes[index],
                                      color: Color.lerp(
                                          Colors.pink,
                                          Colors.orange,
                                          index / routes.length)!,
                                    ),
                                  ));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          ),
        ),
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

  void sortByDifficulty() {
    setState(() {
      if (sortDescending) {
        routes.sort((a, b) => b.difficulty.compareTo(a.difficulty));
      } else {
        routes.sort((a, b) => a.difficulty.compareTo(b.difficulty));
      }
    });
  }

  void sortByName() {
    setState(() {
      if (sortDescending) {
        routes.sort((a, b) => b.name.compareTo(a.name));
      } else {
        routes.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }
}
