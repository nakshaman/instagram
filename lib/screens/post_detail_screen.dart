import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late StreamSubscription subscription;
  late Map<String, dynamic> post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    subscription = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post['postId'])
        .snapshots()
        .listen((snapshot) {
          setState(() {
            post = snapshot.data()!;
          });
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostCard(post: post),
    );
  }
}
