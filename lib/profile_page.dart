
import 'package:climb_it/bar%20chart/bar_graph.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final List<double> vAmounts = [
    0.0,
    1.0,
    2.0,
    3.0,
    4.0,
    5.0,
    6.0,
    7.0,
  ];
  final List<String> centers = ['Center1', 'Center2', 'Center3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(barTitle: 'Profile'),
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
                        child: Image.asset('assets/brix.jpg')),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: SizedBox(
                    height: 200,
                    child: MyBarGraph(vAmmount: vAmounts,
                    ),
                  ),
                )
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


/*
       
      body: Center(
        child: SizedBox(
          height: 200,
          child: MyBarGraph(
            vAmmount: vAmounts,
          )),
      ),
      */