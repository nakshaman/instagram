import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/post.dart';
import 'package:insta/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl = await StorageMethod().storePicture('posts', file, true);

      String postId = uuid.v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postUrl: photoUrl,
        postId: postId,
        datePublished: DateTime.now(),
        profileImage: profileImage,
        likes: [],
        commentCount: 0,
      );

      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      res = "sucess";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // like Post
  Future<void> likePost({
    required String postId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
        // Send Notification
        DocumentSnapshot postSnap = await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .get();
        DocumentSnapshot userSnap = await _firebaseFirestore
            .collection('users')
            .doc(uid)
            .get();

        String targetId = postSnap['uid'];
        String postUrl = postSnap['postUrl'];
        String username = userSnap['username'];
        String profileImage = userSnap['photoUrl'];
        await sendNotification(
          postId: postId,
          senderProfileImage: profileImage,
          senderUid: uid,
          senderUsername: username,
          targetUid: targetId,
          type: 'like',
          postUrl: postUrl,
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // comment on post
  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = uuid.v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
              {
                'profilePic': profilePic,
                'name': name,
                'uid': uid,
                'text': text,
                'commentId': commentId,
                'datePublished': DateTime.now(),
                'likes': [],
              },
            );
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'commentCount': FieldValue.increment(1),
        });
        DocumentSnapshot postSnap = await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .get();
        String targetUid = postSnap['uid'];
        String postUrl = postSnap['postUrl'];
        await sendNotification(
          targetUid: targetUid,
          senderUid: uid,
          senderUsername: name,
          senderProfileImage: profilePic,
          type: 'comment',
          postId: postId,
          commentText: text,
          postUrl: postUrl,
        );
      } else {
        log('comment text is empty');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // like comment

  Future<void> likeComment({
    required String commentId,
    required String uid,
    required List likes,
    required String postId,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
              'likes': FieldValue.arrayRemove([uid]),
            });
      } else {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
              'likes': FieldValue.arrayUnion([uid]),
            });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // delete post
  Future<String> deletePost(String postId) async {
    String res = "Some error occured";
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
      res = "Post deleted successfully";
      QuerySnapshot notificationSnap = await _firebaseFirestore
          .collectionGroup('notification')
          .where('postId', isEqualTo: postId)
          .get();
      for (DocumentSnapshot doc in notificationSnap.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  // follow user
  Future<String> followUser(String uid, String followId) async {
    String res = 'Something error occured';
    try {
      DocumentSnapshot<Map<String, dynamic>> snap = await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .get();
      List following = (snap.data()! as dynamic)['following'];
      // unfollowing
      if (following.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        // following
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
        //  Send Notification
        String username = snap.data()!['username'];
        String profileImg = snap.data()!['photoUrl'];

        await sendNotification(
          targetUid: followId,
          senderUid: uid,
          senderUsername: username,
          type: 'follow',
          senderProfileImage: profileImg,
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

  // send Notification
  Future<void> sendNotification({
    required String targetUid,
    required String senderUid,
    required String senderUsername,
    required String senderProfileImage,
    required String type,
    String postId = '',
    String postUrl = '',
    String commentText = '',
  }) async {
    if (senderUid == targetUid) return;
    try {
      String notificationId = uuid.v1();
      await _firebaseFirestore
          .collection('users')
          .doc(targetUid)
          .collection('notification')
          .doc(notificationId)
          .set({
            'notification': notificationId,
            'type': type,
            'senderUid': senderUid,
            'targetUid': targetUid,
            'senderUsername': senderUsername,
            'senderProfileImage': senderProfileImage,
            'postId': postId,
            'postUrl': postUrl,
            'commentText': commentText,
            'timeStamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      log(e.toString());
    }
  }
}
