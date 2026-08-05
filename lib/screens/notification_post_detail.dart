import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/widgets/post_card.dart';

class NotificationPostDetail extends StatelessWidget {
  final String postId;
  const NotificationPostDetail({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // 💡 Listens to live updates automatically (no manual subscription needed!)
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryColor,
              ),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'This post is no longer available.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final post = snapshot.data!.data()!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: PostCard(post: post),
            ),
          );
        },
      ),
    );
  }
}
