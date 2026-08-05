import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/notification_post_detail.dart';
import 'package:insta/screens/profile_screen.dart';
import 'package:insta/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUid)
            .collection('notification')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder:
            (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> notification,
            ) {
              if (notification.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                );
              }
              if (notification.hasError) {
                return const Center(
                  child: Text('Some error occured'),
                );
              }
              if (!notification.hasData || notification.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No activity yet.'),
                );
              }
              final docs = notification.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final data = docs[index].data();
                  final String type = data['type'] ?? 'like';
                  final String senderUsername = data['senderUsername'] ?? '';
                  final String senderProfileImage =
                      data['senderProfileImage'] ?? '';
                  final String postUrl = data['postUrl'] ?? '';
                  final String postId = data['postId'] ?? '';
                  final String commentText = data['commentText'] ?? '';
                  final String senderUid = data['senderUid'] ?? '';
                  return ListTile(
                    onTap: () {
                      if (type == 'follow') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: senderUid),
                          ),
                        );
                      } else if (postId.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NotificationPostDetail(postId: postId),
                          ),
                        );
                      }
                    },
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(senderProfileImage),
                    ),
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: senderUsername,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          TextSpan(
                            text: type == 'like'
                                ? ' liked your post'
                                : type == 'comment'
                                ? ' commented $commentText'
                                : ' started following you',
                          ),
                        ],
                      ),
                    ),
                    trailing: (type != 'follow' && postUrl.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              postUrl,
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                  );
                },
              );
            },
      ),
    );
  }
}
