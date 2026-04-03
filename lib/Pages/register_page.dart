import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // Function to store user data in Firestore
  Future<void> storeUserData(String uid, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    if (passwordController.text != conPasswordController.text) {
      Navigator.pop(context);
      displayMessage('Passwords don\'t match');
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // Store additional user details in Firestore
      await storeUserData(
          userCredential.user!.uid, nameController.text, emailController.text);

      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    backgroundImage: const AssetImage('assets/2.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: const Text(
                      "Hello There",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                    ),
                    subtitle: Text(
                      "We are so Happy to see you here.",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextfield(
                      controller: nameController,
                      hinText: 'Enter Name',
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextfield(
                      controller: emailController,
                      hinText: 'Enter Email',
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextfield(
                      controller: passwordController,
                      hinText: 'Enter Password',
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextfield(
                      controller: conPasswordController,
                      hinText: 'Confirm Password',
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    text: 'Sign Up',
                    onTap: signUp,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
