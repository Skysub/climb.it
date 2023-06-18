import 'dart:convert';
import 'dart:math';

import 'package:climb_it/gyms/route_item.dart';
import 'package:climb_it/gyms/route_page.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'climbing_route.dart';
import 'gym.dart';

class GymOverview extends StatefulWidget {
  final Gym gym;
  const GymOverview({super.key, required this.gym});

  @override
  State<GymOverview> createState() => GymOverviewState();
}

enum CompletionSortMode {
  any,
  completed,
  notCompleted;

  @override
  String toString() {
    switch (this) {
      case CompletionSortMode.any:
        return 'Any';
      case CompletionSortMode.completed:
        return 'Completed';
      case CompletionSortMode.notCompleted:
        return 'Not Completed';
    }
  }

  bool highlighted() {
    return this != CompletionSortMode.any;
  }

  CompletionSortMode next() {
    switch (this) {
      case CompletionSortMode.any:
        return CompletionSortMode.completed;
      case CompletionSortMode.completed:
        return CompletionSortMode.notCompleted;
      case CompletionSortMode.notCompleted:
        return CompletionSortMode.any;
    }
  }
}

class GymOverviewState extends State<GymOverview> {
  late Future<List<ClimbingRoute>> routeFuture;
  List<ClimbingRoute> displayedRoutes = [];
  List<ClimbingRoute> routes = [];

  CompletionSortMode completeMode = CompletionSortMode.any;
  bool sortGradeDescending = false;

  Set<String> tagFilters = {};
  Map<String, dynamic> completedMap = {};

  @override
  void initState() {
    super.initState();
    routeFuture = getRouteData();
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
              Row(children: [
                ActionChip(
                    label: const Text('Grade',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.pink,
                    avatar: Icon(
                        sortGradeDescending
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: Colors.white),
                    onPressed: () {
                      setState(() {
                        sortGradeDescending = !sortGradeDescending;
                        sortRoutes();
                      });
                    }),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(spacing: 10, children: [
                          ActionChip(
                              label: Text(completeMode.toString(),
                                  style: TextStyle(
                                      color: completeMode.highlighted()
                                          ? Colors.white
                                          : null)),
                              backgroundColor: completeMode.highlighted()
                                  ? Colors.pink
                                  : null,
                              onPressed: () {
                                setState(() {
                                  completeMode = completeMode.next();
                                  sortRoutes();
                                });
                              }),
                          ActionChip(
                              label: Text('Tags',
                                  style: TextStyle(
                                      color: tagFilters.isNotEmpty
                                          ? Colors.white
                                          : null)),
                              backgroundColor:
                                  tagFilters.isEmpty ? null : Colors.pink,
                              //TODO Extract Dialog to separate Widget
                              onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                            builder: (context, setState) =>
                                                Dialog(
                                                    child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Wrap(
                                                    spacing: 5,
                                                    children: [
                                                      for (String tag
                                                          in getAllTags())
                                                        FilterChip(
                                                            elevation: 3,
                                                            checkmarkColor:
                                                                Colors.white,
                                                            selectedColor:
                                                                Colors.pink,
                                                            label: Text(tag,
                                                                style: TextStyle(
                                                                    color: tagFilters.contains(
                                                                            tag)
                                                                        ? Colors
                                                                            .white
                                                                        : null)),
                                                            selected: tagFilters
                                                                .contains(tag),
                                                            onSelected:
                                                                (selected) {
                                                              setState(() {
                                                                if (selected) {
                                                                  tagFilters
                                                                      .add(tag);
                                                                } else {
                                                                  tagFilters
                                                                      .remove(
                                                                          tag);
                                                                }
                                                              });
                                                            })
                                                    ],
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Close',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.pink)))
                                                ],
                                              ),
                                            )),
                                          )).then((value) {
                                    setState(() {
                                      sortRoutes();
                                    });
                                  })),
                        ])))
              ]),
              const SizedBox(height: 10),
              Flexible(
                child: FutureBuilder(
                    future: routeFuture,
                    builder: (context, routeSnapshot) {
                      if (routeSnapshot.hasData) {
                        routes = routeSnapshot.data!;
                        sortRoutes();
                        if (routeSnapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('This gym currently has no routes.'));
                        } else {
                          return Scrollbar(
                            child: ListView.separated(
                                itemCount: displayedRoutes.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 15),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => RoutePage(
                                                      route: displayedRoutes[
                                                          index],
                                                      callback:
                                                          changeCompletedStatus,
                                                    )))
                                      },
                                      child: RouteItem(
                                          climbingRoute:
                                              displayedRoutes[index]),
                                    )),
                          );
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
      routeFuture = getRouteData();
    });
  }

  Future<List<ClimbingRoute>> getRouteData() async {
    // Load Firebase data
    var data = await FirebaseDatabase.instance
        .ref()
        .child('routes')
        .child(widget.gym.key)
        .once();
    routes = data.snapshot.children
        .map((e) => ClimbingRoute.fromJSON(
            e.value as Map,
            e.child('hints').value == null
                ? null
                : e.child('hints').value as Map,
            e.key ?? ''))
        .toList();

    // Load completed routes map from shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? completedString = prefs.getString('routesCompleted');
    completedMap = completedString != null ? jsonDecode(completedString) : {};

    setCompletedStatus();

    return routes;
  }

  changeCompletedStatus(ClimbingRoute route, bool isCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (isCompleted) {
        completedMap[route.key] = isCompleted;
        prefs.setInt('V${route.difficulty}',
            (prefs.getInt('V${route.difficulty}') ?? 0) + 1);
      } else {
        completedMap.remove(route.key);
        prefs.setInt('V${route.difficulty}',
            max((prefs.getInt('V${route.difficulty}') ?? 0) - 1, 0));
      }
      setCompletedStatus();
      saveRouteData();
    });
  }

  void setCompletedStatus() {
    for (ClimbingRoute route in routes) {
      route.isCompleted = completedMap[route.key] ?? false;
    }
  }

  saveRouteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("routesCompleted", jsonEncode(completedMap));
  }

  void updateRouteCompleted() {}

  void sortRoutes() {
    // Save all routes in displayedRoutes
    displayedRoutes = routes;

    // Filter routes by completed
    if (completeMode != CompletionSortMode.any) {
      bool onlyCompleted = completeMode == CompletionSortMode.completed;
      displayedRoutes = displayedRoutes
          .where((route) => route.isCompleted == onlyCompleted)
          .toList();
    }

    // Filter by tags
    if (tagFilters.isNotEmpty) {
      displayedRoutes = displayedRoutes
          .where((route) => route.tags.any((tag) => tagFilters.contains(tag)))
          .toList();
    }

    // Sort remaining routes
    displayedRoutes.sort((a, b) => a.difficulty.compareTo(b.difficulty));

    // Set sort order
    if (sortGradeDescending) {
      displayedRoutes = displayedRoutes.reversed.toList();
    }
  }

  List<String> getAllTags() {
    Set<String> tagSet = {};
    for (var route in routes) {
      tagSet.addAll(route.tags);
    }
    List<String> tagList = tagSet.toList();
    tagList.sort();
    return tagList;
  }
}
