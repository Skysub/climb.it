import 'package:cached_network_image/cached_network_image.dart';
import 'package:climb_it/gyms/gym_overview.dart';
import 'package:climb_it/gyms/tags.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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
  SharedPreferences? preferences;

  Future<void> initStorage() async {
    preferences = await SharedPreferences.getInstance();
    // init 1st time 0
    int? savedData = preferences?.getInt("counter");
    if (savedData == null) {
      await preferences!.setDouble("Attempts", attemptCounter);
    } else {
      attemptCounter = savedData as double;
    }
    setState(() {});
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
    initStorage();
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
          Row(children: [
            CustomizableCounter(
              borderColor: Colors.redAccent,
              backgroundColor: Colors.redAccent,
              borderWidth: 5,
              borderRadius: 100,
              buttonText: 'Click me after an atempt!',
              showButtonText: true,
              //TODO Handle null value. Changed ! to ? since value was null
              count: preferences?.getDouble("counter") ?? 0,
              step: 1,
              minCount: 0,
              incrementIcon: const Icon(
                Icons.add,
                color: Colors.orange,
              ),
              decrementIcon: const Icon(
                Icons.remove,
                color: Colors.orange,
              ),
              onIncrement: (e) => attemptCounter = e,
            ),
            Expanded(
                child: OutlinedButton(
                    child: Text("Hint"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () => {showHint(HintType.text, "Bruh")}))
          ])
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
