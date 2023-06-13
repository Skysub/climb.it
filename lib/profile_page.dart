import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final List<String> centers = ['Center1', 'Center2', 'Center3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(barTitle: 'Profile'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                  width: 150,
                  height: 150,
                  child: IconButton(
                    icon: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('brix.jpg')),
                    iconSize: 50,
                    onPressed: () {},
                  )),
              const SizedBox(height: 5),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Christian Brix'),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {},
                      child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Align(
                  alignment: Alignment.centerLeft, child: Text('Routes:')),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('0'),
                  Text('1'),
                  Text('2'),
                  Text('3'),
                  Text('4'),
                  Text('5'),
                  Text('6'),
                  Text('7'),
                ],
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('V0'),
                  Text('V1'),
                  Text('V2'),
                  Text('V3'),
                  Text('V4'),
                  Text('V5'),
                  Text('V6'),
                  Text('V7'),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    const Text('Most Visited Centres:'),
                    const SizedBox(height: 10),
                    for (var center in centers) Text(center)
                  ]),
                  Column(
                    children: [
                      const Text('Recently Visited Centres:'),
                      const SizedBox(height: 10),
                      for (var center in centers.reversed) Text(center)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
