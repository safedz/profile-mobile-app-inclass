import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Profile',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadSavedProfileImage();
  }


  Future<void> _loadSavedProfileImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final file = File(
        '${directory.path}/profile_picture.jpg',
      );

      if (await file.exists()) {
        setState(() {
          _profileImage = file;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile image: $e');
    }
  }


  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Take a photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Choose from gallery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),

           
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedImage == null) {
        return;
      }

  
      final directory =
          await getApplicationDocumentsDirectory();

  
      final savedImage = File(
        '${directory.path}/profile_picture.jpg',
      );


      await File(pickedImage.path).copy(
        savedImage.path,
      );

      setState(() {
        _profileImage = savedImage;
      });
    } catch (e) {
      debugPrint('Error selecting image: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to select the image.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,

        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

     
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 38,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 18),

            
              Center(
                child: GestureDetector(
                  onTap: _showImageOptions,

                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [

                
                      Container(
                        width: 136,
                        height: 136,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,

                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),

                        padding: const EdgeInsets.all(8),

                        child: ClipOval(
                          child: _profileImage != null
                              ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/profile.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                   
                      Positioned(
                        right: 5,
                        bottom: 20,

                        child: Container(
                          width: 38,
                          height: 38,

                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),

                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 46,
                            weight: 900,
                          ),
                        ),
                      ),

                   
                      Positioned(
                        right: -4,
                        bottom: -4,

                        child: Container(
                          width: 32,
                          height: 32,

                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,

                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),

                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

             
              const Divider(
                color: Colors.black,
                thickness: 1.5,
              ),

              const SizedBox(height: 14),

            
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Sineli',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 28),

            
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: const [

                  Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 20,
                  ),

                  SizedBox(width: 10),

                  Text(
                    'sineli.f@nsbm.ac.lk',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

             
              const Text(
                'Points',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: const [

                  Icon(
                    Icons.star,
                    color: Colors.black,
                    size: 20,
                  ),

                  SizedBox(width: 10),

                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 5,

        onPressed: () {
         
        },

        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}