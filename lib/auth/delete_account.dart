import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:godalone/auth/auth.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> deleteUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .delete();

      final userPosts = await FirebaseFirestore.instance
          .collection('Posts')
          .where('UserEmail', isEqualTo: currentUser.email)
          .get();

      for (var doc in userPosts.docs) {
        await doc.reference.delete();
      }
    } catch (_) {}
  }

  Future<void> deleteAccount() async {
    try {
      await deleteUserData();
      await currentUser.delete();
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AuthPage()));
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please log out and log back in before deleting your account.'),
        ));
      }
    }
  }

  void showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteAccount();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Center(
        child: ElevatedButton(
          onPressed: showDeleteAccountDialog,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete My Account',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
