import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/post.dart';
import 'package:insta/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
}
