import 'dart:convert';
import 'dart:io';
import 'dart:math';
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
  String profileName = 'Profile Name';

  Image profileImage =
      Image.asset('assets/defaultprofile.png', fit: BoxFit.cover);
  ImagePicker imagePicker = ImagePicker();

  final List<double> vAmounts = [0, 0, 0, 0, 0, 0, 0, 0];
  final List<String> centers = ['Center1', 'Center2', 'Center3'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

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
                    width: 175,
                    height: 175,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(175),
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
                  const Spacer(),
                  Text(
                    profileName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showChangeNameDialog();
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              const Text('Routes Completed:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              FutureBuilder(
                  future: _loadAmounts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (vAmounts.reduce(max) == 0) {
                        return const Column(children: [
                          SizedBox(height: 10),
                          Text(
                              'Complete a route come back\nto track your progression!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ]);
                      }
                      return SizedBox(
                        height: 200,
                        child: MyBarGraph(
                          amounts: vAmounts,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              'Most Visited Centres',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          for (var center in centers)
                            Text(center,
                                style: const TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 450,
                      top: 5,
                      child: Icon(
                        Icons.house,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              'Recently Visited Centres',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          for (var center in centers.reversed)
                            Text(center,
                                style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 450,
                      top: 5,
                      child: Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
    String? newName = await showDialog(
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
    if (newName != '' && newName != null) {
      setState(() {
        profileName = newName;
      });
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('profile_name', profileName);
    }
  }

  _getFromGallery() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);
    await _saveImage(img);
  }

  _getFromCamera() async {
    var img = await imagePicker.pickImage(source: ImageSource.camera);
    await _saveImage(img);
  }

  _saveImage(XFile? img) async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      if (img != null) {
        File imageFile = File(img.path);
        profileImage = Image.file(imageFile, fit: BoxFit.cover);
        prefs.setString(
            'profile_image', base64Encode(imageFile.readAsBytesSync()));
      }
    });
  }

  _loadProfile() {
    SharedPreferences.getInstance().then((prefs) {
      // Load profile name
      profileName = prefs.getString('profile_name') ?? 'Profile Name';
      // Load profile image from base64
      String? imageBase64 = prefs.getString('profile_image');
      if (imageBase64 != null) {
        try {
          profileImage =
              Image.memory(base64Decode(imageBase64), fit: BoxFit.cover);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }
}
