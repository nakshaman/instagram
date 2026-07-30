import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postUrl;
  final String postId;
  final datePublished;
  final String profileImage;
  final  likes;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postUrl,
    required this.postId,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postUrl": postUrl,
    "postId": postId,
    "datePublished": datePublished,
    "profileImage": profileImage,
    "likes": likes,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postUrl: snapshot['postUrl'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
