import 'package:cached_network_image/cached_network_image.dart';
import 'package:climb_it/gyms/tags.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'climbing_route.dart';
import 'hint.dart';

typedef CompletedCallback = void Function(ClimbingRoute, bool);

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.route, required this.callback});

  final ClimbingRoute route;
  final CompletedCallback callback;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  Map<String, Future<void>> initVideoPlayerFutures = {};
  late Map<String, VideoPlayerController> videoHintControllers;
  double attemptCounter = 0;

  @override
  void initState() {
    //We start by preloading all the hint videos for this route if applicable
    var videoHints =
        widget.route.hints.where((e) => e.type == HintType.video).toList();
    //Grimt udtryk nedenunder, kig væk!
    videoHintControllers = Map<String, VideoPlayerController>.fromEntries(
        Iterable<MapEntry<String, VideoPlayerController>>.generate(
            videoHints.length,
            (i) => MapEntry<String, VideoPlayerController>(videoHints[i].data,
                VideoPlayerController.network(videoHints[i].data))));
    videoHintControllers.forEach((key, value) {
      initVideoPlayerFutures.putIfAbsent(key, () => value.initialize());
      value.setLooping(false);
      value.setVolume(1.0);
    });

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
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.route.imageUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FlutterSwitch(
                          width: 180,
                          inactiveText: "Not Completed",
                          activeText: "Completed!",
                          padding: 8,
                          activeColor: Colors.green,
                          inactiveColor: Colors.red,
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.white,
                          activeTextFontWeight: FontWeight.bold,
                          inactiveTextFontWeight: FontWeight.bold,
                          toggleColor: Colors.white,
                          value: widget.route.isCompleted,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              widget.route.isCompleted = val;
                              widget.callback(widget.route, val);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Tags(
                      tags: widget.route.tags,
                      color: widget.route.color,
                    ),
                    const SizedBox(height: 10),
                    if (widget.route.hints.isNotEmpty)
                      Center(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () => {showHintSelector()},
                            child: const Text("Need A Hint?")),
                      ),
                  ],
                ),
              ),
              // TODO Move video player
              // FutureBuilder(
              //     future: _initializeVideoPlayerFuture,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.done) {
              //         return Center(
              //           child: AspectRatio(
              //               aspectRatio: _controller.value.aspectRatio,
              //               child: VideoPlayer(_controller)),
              //         );
              //       } else {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //     }),
              // FloatingActionButton(
              //   onPressed: () {
              //     setState(() {
              //       if (_controller.value.isPlaying) {
              //         _controller.pause();
              //       } else {
              //         _controller.play();
              //       }
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  showHintSelector() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                scrollable: true,
                title: const Text("Choose a hint"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List<ElevatedButton>.generate(
                      widget.route.hints.length,
                      (i) => ElevatedButton(
                            child: Text(widget.route.hints[i].name),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  traversalEdgeBehavior:
                                      TraversalEdgeBehavior.closedLoop,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title:
                                              Text(widget.route.hints[i].name),
                                          content: getHintContentWidget(
                                              widget.route.hints[i]),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ])).whenComplete(() =>
                                  videoHintControllers.forEach((key, value) {
                                    if (value.value.isPlaying) {
                                      value.pause();
                                    }
                                  }));
                            },
                          )),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ]));
  }

  Widget getHintContentWidget(Hint hint) {
    switch (hint.type) {
      case HintType.text:
        return Text(hint.data);

      case HintType.image:
        return CachedNetworkImage(
            imageUrl: hint.data,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()));

      case HintType.video:
        //TODO: Make UI good
        return Column(children: [
          FutureBuilder(
              future: initVideoPlayerFutures[hint.data],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                      child: AspectRatio(
                          aspectRatio: videoHintControllers[hint.data]!
                              .value
                              .aspectRatio,
                          child:
                              VideoPlayer(videoHintControllers[hint.data]!)));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (videoHintControllers[hint.data]!.value.isPlaying) {
                  videoHintControllers[hint.data]!.pause();
                } else {
                  videoHintControllers[hint.data]!.play();
                }
              });
            },
          )
        ]);
    }
  }
}
