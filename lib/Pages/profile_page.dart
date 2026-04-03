import 'dart:io'; // For File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import '../auth/changepassword.dart';
import '../auth/changeusername.dart';
import '../auth/delete_account.dart';
import '../auth/login_or_register.dart';
import '../components/settings_tile.dart';
import '../themes/theme_provider.dart';
import 'SubPages/give.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String username = '';
  File? _profileImage; // File to store selected profile image
  String? profileImageUrl; // String to store profile image URL
  bool _isLoading = true;

  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  // Fetch user data (username and profile picture URL) from Firestore
  void fetchUserProfile() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        username = userData?['name'] ?? currentUser.email!.split('@')[0];
        profileImageUrl =
            userData?['profilePicUrl']; // Get profile image URL from Firestore
        _isLoading = false;
      });
    } else {
      setState(() {
        username = currentUser.email!.split('@')[0];
        _isLoading = false;
      });
    }
  }

  // Function to pick an image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _uploadProfileImage(_profileImage!);
    }
  }

  // Function to upload profile image to Firebase Storage and save URL to Firestore
  Future<void> _uploadProfileImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${currentUser.uid}.jpg');
      await storageRef.putFile(image);
      String downloadURL = await storageRef.getDownloadURL();

      // Save the download URL in Firestore and update Firebase Auth profile
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'profilePicUrl': downloadURL});
      await currentUser.updatePhotoURL(downloadURL);

      setState(() {
        profileImageUrl = downloadURL; // Update profile image URL in state
        _isLoading = false;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()));
  }

  Future<void> saveBio() async {
    setState(() {
      _isLoading = true;
    });
    // Handle bio update logic here
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _isLoading
              ? CircularProgressIndicator()
              : Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            // Email display
            Center(
              child: Text(currentUser.email!),
            ),
            const SizedBox(
              height: 20,
            ),
            // Profile picture with edit option
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 80,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : profileImageUrl != null
                            ? NetworkImage(
                                profileImageUrl!) // Load profile image URL from Firebase
                            : null,
                    child: _profileImage == null && profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.add_circle_sharp, size: 35),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _buildBottomSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Other UI settings like Dark Mode, Change Username, etc.
            MySettingsTile(
              title: 'Dark Mode',
              action: CupertinoSwitch(
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'OPTIONS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.secondary,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeUsernamePage(user: currentUser);
                }));
              },
              leading: const Icon(UniconsLine.user_square),
              title: const Text(
                'Change Username',
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.secondary,
              onTap: () {
                // Navigate to ChangePasswordPage and pass the currentUser
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(user: currentUser),
                  ),
                );
              },
              leading: const Icon(UniconsLine.lock_access),
              title: const Text(
                'Change Password',
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.secondary,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const Give(isBottomSheet: true),
                );
              },
              leading: const Icon(Icons.mobile_friendly_sharp),
              title: const Text(
                'Give',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Text(
              'SUPPORT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.secondary,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DeleteAccountPage();
                }));
              },
              leading: const Icon(Icons.message_sharp),
              title: const Text(
                'Delete Account',
              ),
            ),
            TextButton(
                onPressed: logOut,
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }

  // Bottom sheet to pick image from camera or gallery
  Widget _buildBottomSheet() {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Take a picture'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
