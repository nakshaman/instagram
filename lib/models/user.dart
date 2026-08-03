import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "photoUrl": photoUrl,
    "email": email,
    "bio": bio,
    "followers": followers,
    "following": following,
  };

  static User fromSnap(DocumentSnapshot snap) {
    final data = snap.data();

    if (data == null) {
      throw Exception("User document does not exist.");
    }

    final snapshot = data as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
