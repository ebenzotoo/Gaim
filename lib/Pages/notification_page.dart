import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:godalone/components/wall_post.dart';
import 'package:unicons/unicons.dart';
import '../helper/helper_methods.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(
        child: Text('Please log in to view notifications.'),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              UniconsLine.times_circle,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Notifications")
                .where("NotifiedUser", isEqualTo: currentUser!.email)
                .orderBy("Time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              print('Stream Connection State: ${snapshot.connectionState}');
              print('Has Data: ${snapshot.hasData}');
              print('Has Error: ${snapshot.hasError}');

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print('Error: ${snapshot.error}'); // Print the error
                return const Center(child: Text('Error loading notifications'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No notifications'));
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  final notificationData = doc.data() as Map<String, dynamic>;
                  print(
                      'Notification Data: $notificationData'); // Print notification data

                  return ListTile(
                    title: Text(
                      notificationData["Message"] ?? 'You have a notification',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(formatDate(notificationData[
                        "Time"])), // Make sure this is correctly formatted
                    onTap: () {
                      _navigateToPost(notificationData["PostId"],
                          doc.id); // Pass the document ID to delete it
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToPost(String postId, String notificationId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .get()
        .then((postDoc) {
      if (postDoc.exists) {
        final postData = postDoc.data()!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallPost(
              message: postData['Message'],
              user: postData['UserEmail'],
              likes: List<String>.from(postData['Likes'] ?? []),
              postId: postDoc.id,
              time: formatDate(postData['TimeStamp']),
            ),
          ),
        ).then((_) {
          // After navigating back, delete the notification
          _deleteNotification(notificationId);
        });
      } else {
        _displayMessage('Post not found!');
      }
    }).catchError((error) {
      print('Error fetching post: $error');
      _displayMessage('Error loading post: $error');
    });
  }

  void _deleteNotification(String notificationId) {
    FirebaseFirestore.instance
        .collection("Notifications")
        .doc(notificationId)
        .delete()
        .then((_) {
      print('Notification deleted successfully');
    }).catchError((error) {
      print('Error deleting notification: $error');
    });
  }

  void _displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }
}
