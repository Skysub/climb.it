import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RoutePage extends StatefulWidget {
  RoutePage() : super();

  final String title = "Routes 4";

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley");
    //_controller = VideoPlayerController.asset("videos/sample_video.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(barTitle: 'Selected Route'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.fill,
                child: Image.asset(
                    'boulderingrouteholder.jpg'), //Placeholder picture
              ),
              const SizedBox(height: 50),
              const Align(
                  alignment: Alignment.centerLeft, child: Text('Grade: ')),
              //Get the grade assigned to the route
              const Align(
                  alignment: Alignment.centerLeft, child: Text('Tags: ')),
              //Get the tags assigned to the route
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Need a hint?'),
              ),
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (content, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    );
                  } else return CircularProgressIndicator();
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Center(
      child: SizedBox(
        width: 350,
        height: 350,
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : Container(),
      ),
    );
  }
}
