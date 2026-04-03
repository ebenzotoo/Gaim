import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:godalone/components/comment.dart';
import 'package:godalone/components/comment_button.dart';
import 'package:godalone/components/delete_button.dart';
import 'package:godalone/components/like_button.dart';
import 'package:godalone/components/my_input_alert_box.dart';
import 'package:godalone/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final dynamic postId;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.likes,
    required this.postId,
    required this.time,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  String? profileImageUrl;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    fetchUserProfileImage();
  }

  Future<void> fetchUserProfileImage() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: widget.user)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      if (mounted) {
        setState(() {
          profileImageUrl = userData['profilePicUrl'];
        });
      }
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
      addNotification('Someone liked your post!', widget.postId);
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
    addNotification('Someone commented on your post!', widget.postId);
  }

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
            textController: _commentTextController,
            hintext: 'Write a comment',
            onPressed: () => addComment(_commentTextController.text),
            onPressedText: 'Comment'));
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete this?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }

                      await FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(widget.postId)
                          .delete();

                      if (mounted) navigator.pop();
                    },
                    child: const Text('Delete'))
              ],
            ));
  }

  void addNotification(String message, String postId) {
    FirebaseFirestore.instance.collection("Notifications").add({
      "Message": message,
      "Time": Timestamp.now(),
      "PostId": postId,
      "NotifiedUser": widget.user,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.user == currentUser.email)
              Align(
                alignment: Alignment.bottomRight,
                child: DeleteButton(onTap: deletePost),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: profileImageUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl!),
                      radius: 25,
                    )
                  : Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              title: Text(
                widget.user,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                widget.time,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 10),
              ),
            ),
            Text(
              widget.message,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                LikeButton(isLiked: isLiked, onTap: toggleLike),
                const SizedBox(width: 10),
                Text(widget.likes.length.toString()),
                const Spacer(),
                CommentButton(onTap: showCommentDialog),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
