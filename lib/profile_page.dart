import 'dart:io';
import 'package:climb_it/bar%20chart/bar_graph.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Profile Name';

void setName(String name) {
  this.name = name;
}

  final List<double> vAmounts = [
    14.0,
    11.0,
    8.0,
    6.0,
    9.0,
    10.0,
    6.0,
    7.0,
  ];

  final List<String> centers = ['Center1', 'Center2', 'Center3'];

  Image? profileImage = Image.asset('assets/defaultprofile.png');
  ImagePicker image = ImagePicker();

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
              Stack(
                children: [
                  SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: profileImage),
                      ),
                  Positioned(
                    bottom: 30,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.pink,
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) =>  SimpleDialog(
                              title: const Center(
                                child: Text('Change Profile Picture')),
                              children: [
                                const Center(
                                  child: Text('Select Option')),
                                TextButton(
                                  onPressed: () {
                                    getFromGallery();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Select from gallery'),
                                  ),
                                TextButton(
                                  onPressed: () {
                                    getFromCamera();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Take from camera'),
                                  ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Text(
                        name, 
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                      ),),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                      _showChangeNameDialog();
                      },
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(
                    color: Colors.orange,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [ 
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4,
                    )
                  ]
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        children: [
                          const Text('Routes:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(
                            height: 200,
                            child: MyBarGraph(vAmmount: vAmounts,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  border: Border.all(
                    color: Colors.pink,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(
                    color: Colors.black,
                    blurRadius: 4,
                  ),],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      const Text('Most Visited Centres:', 
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                      const SizedBox(height: 10),
                      for (var center in centers) Text(center)
                    ]),
                    Column(
                      children: [
                        const Text('Recently Visited Centres:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                        const SizedBox(height: 10),
                        for (var center in centers.reversed) Text(center)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  
  void _showChangeNameDialog() async {
    String newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String textFieldValue = '';

        return AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            onChanged: (value) {
              textFieldValue = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textFieldValue);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != '') {
      setState(() {
        name = newName;
      });
    }
  }

  getFromGallery() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = Image.file(File(img!.path));
    });
  }
  getFromCamera() async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      profileImage = Image.file(File(img!.path));
    });
  }
}


  

