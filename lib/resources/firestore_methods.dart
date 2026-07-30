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
              },
            );
      } else {
        log('comment text is empty');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
