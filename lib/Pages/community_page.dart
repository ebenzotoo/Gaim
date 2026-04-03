import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../components/Constants/colors.dart';
import '../components/my_input_alert_box.dart';
import '../components/wall_post.dart';
import '../helper/helper_methods.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  // Function to post a message to Firestore
  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'GAIM Community',
            style: TextStyle(color: myMainColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
                    .orderBy("TimeStamp",
                        descending:
                            true) // Sort in descending order for latest post on top
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          likes: List<String>.from(post['Likes'] ?? []),
                          postId: post.id,
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(25),
              child: Row(
                children: [Expanded(child: SizedBox())],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBarModalBottomSheet(
              context: context,
              builder: (context) {
                return MyPostMessageBox(
                  textController: textController,
                  hintext: 'What’s on your mind?',
                  onPressed: postMessage,
                  onPressedText: 'Post',
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
