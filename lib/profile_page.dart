import 'dart:io';
import 'package:climb_it/bar%20chart/bar_graph.dart';
import 'package:climb_it/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Profile Name';

  Image profileImage = Image.asset('assets/defaultprofile.png', fit: BoxFit.cover);
  ImagePicker imagePicker = ImagePicker();

  final List<double> vAmounts = [0, 0, 0, 0, 0, 0, 0, 0];
  final List<String> centers = ['Center1', 'Center2', 'Center3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MainAppBar(barTitle: 'Profile'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(300),
                        child: profileImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.orange),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Center(
                                child: Text('Change Profile Picture')),
                            children: [
                              const Center(child: Text('Select Option')),
                              TextButton(
                                onPressed: () {
                                  _getFromGallery();
                                  Navigator.pop(context);
                                },
                                child: const Text('Select from gallery'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _getFromCamera();
                                  Navigator.pop(context);
                                },
                                child: const Text('Take from camera'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      _showChangeNameDialog();
                    },
                    child: Container(
                        width: 25,
                        height: 25,
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
              const SizedBox(height: 30),
              const Text('Routes Completed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 200,
                child: FutureBuilder(
                    future: _loadAmounts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return MyBarGraph(
                          amounts: vAmounts,
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Recently Visited Centres:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (var center in centers) Text(center)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Recently Visited Centres:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (var center in centers.reversed) Text(center)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<double>> _loadAmounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 8; i++) {
      vAmounts[i] = prefs.getInt('V$i')?.toDouble() ?? 0;
    }
    return vAmounts;
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

  _getFromGallery() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        profileImage = Image.file(File(img.path), fit: BoxFit.cover);
      }
    });
  }

  _getFromCamera() async {
    var img = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (img != null) {
        profileImage = Image.file(File(img.path), fit: BoxFit.cover);
      }
    });
  }
}
