import 'package:cached_network_image/cached_network_image.dart';
import 'package:climb_it/gyms/gym_overview.dart';
import 'package:climb_it/gyms/tags.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_switch/flutter_switch.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.route});

  final ClimbingRoute route;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double attemptCounter = 0;
  bool routeCompleted = false;
  late SharedPreferences preferences;

  _saveRouteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("routedCompleted", routeCompleted);
  }

  _loadRouteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      routeCompleted = prefs.getBool("routeCompleted")!;
    });
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(barTitle: widget.route.name),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.route.imageUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
          ),
          Text(widget.route.name),
          Tags(tags: widget.route.tags, color: widget.route.color),
          FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller)),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
          const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: FlutterSwitch(
                    width: 160,
                    inactiveText: "Not Completed",
                    activeText: "Completed!",
                    padding: 8,
                    inactiveColor: Colors.pink,
                    activeColor: Colors.orange,
                    toggleColor: Colors.black,
                    value: routeCompleted,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        routeCompleted = val;
                        _saveRouteData();
                      });
                    },
                  )),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () => {showHint(HintType.text, "Bruh")},
                          child: const Text("Hint")))
                ],
              )),
        ],
      )),
    );
  }

  showHint(HintType ht, String data) async {
    switch (ht) {
      case HintType.text:
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: const Text('Hint'),
                    content: Text(data),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ]));
        break;
      case HintType.image:
        break;
      default:
    }
  }
}

enum HintType { image, text }
