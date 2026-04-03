import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:godalone/auth/auth.dart';
import 'package:godalone/components/Constants/colors.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  const ChangePasswordPage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPasswordEntered = false;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(() {
      setState(() {
        isPasswordEntered = newPasswordController.text.isNotEmpty;
      });
    });
  }

  void changePassword() async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      _showMessage('New password and confirm password do not match.');
      return;
    }

    try {
      final authCredential = EmailAuthProvider.credential(
        email: widget.user.email!,
        password: currentPassword,
      );
      await widget.user.reauthenticateWithCredential(authCredential);
      await widget.user.updatePassword(newPassword);

      _showMessage('Password changed successfully.');
      _clearFields();
      setState(() {
        isPasswordEntered = false;
      });
    } catch (e) {
      _showMessage(
          'Failed to change password. Please check your current password.');
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthPage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isPasswordEntered ? changePassword : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPasswordEntered ? myMainColor : Colors.grey,
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: isPasswordEntered ? Colors.white : Colors.black,
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
