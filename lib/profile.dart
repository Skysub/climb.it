import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
   ProfilePage({super.key});

  List<String>centres = [
    'Center1',
    'Center2',
    'Center3',
    'Center4',
    'Center5',
    'Center6'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 150,
          height: 150,
          child: IconButton(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(100) ,
              child: Image.asset('brix.jpg')
            ),
            iconSize: 50,
            onPressed: () {},
          )
          ),
          Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Christian Brix'),
              const SizedBox(
                width: 5,
                height: 5,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 12,
                    color: Colors.white,
                    )  
                    ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Text('Routes:'),
                  padding: EdgeInsets.fromLTRB(10, 50, 0, 10)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
                    child: Text('Most Visited Centres:'),
                  ),
                  /*ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: centres.length,
                    itemBuilder: (context, index){
                      final center = centres[index];
                      return ListTile(title: Text(center),);
                    },
                    )*/
                ]
              ),
              Column(
                children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 10, 0),
                    child: Text('Recently Visited Centres:'),
                  ),
                  /*ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: centres.length,
                    itemBuilder: (context, index){
                      final center = centres[index];
                      return ListTile(title: Text(center),);
                    },
                    )*/
                ],
              )
            ],
          )
      ],
    );
  }
  
}