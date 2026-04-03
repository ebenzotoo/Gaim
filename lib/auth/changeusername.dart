import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godalone/auth/auth.dart';
import 'package:godalone/components/Constants/colors.dart';

class ChangeUsernamePage extends StatefulWidget {
  final User user; // The authenticated user object from Firebase

  const ChangeUsernamePage({super.key, required this.user});

  @override
  _ChangeUsernamePageState createState() => _ChangeUsernamePageState(); // ignore: library_private_types_in_public_api
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final TextEditingController newUsernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isUsernameEntered = false; // Track if the user has entered text

  void changeUsername() async {
    String newUsername = newUsernameController.text;

    if (newUsername.isEmpty) {
      _showMessage('Username cannot be empty.');
      return;
    }

    try {
      // Update username in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'name': newUsername});

      // Update the display name in Firebase Authentication
      await widget.user.updateDisplayName(newUsername);

      // Show success message
      _showMessage('Username changed successfully.');
      newUsernameController.clear();
      setState(() {
        isUsernameEntered = false; // Reset button color after success
      });
    } catch (e) {
      // Handle error during username change
      _showMessage('Failed to change username. Please try again.');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return AuthPage();
                }));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Listen to changes in the username input
    newUsernameController.addListener(() {
      setState(() {
        // Check if the username field has at least one character
        isUsernameEntered = newUsernameController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Username')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: newUsernameController,
                decoration: const InputDecoration(labelText: 'New Username'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isUsernameEntered
                    ? changeUsername
                    : null, // Enable button if text is entered
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUsernameEntered
                      ? myMainColor // Change to blue if the user enters text
                      : Colors.grey, // Default color when no text is entered
                ),
                child: Text(
                  'Change Username',
                  style: TextStyle(
                    color: isUsernameEntered
                        ? Colors.white // Change to blue if the user enters text
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
