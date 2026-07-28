import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          file != null) {
        // register user
        final UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        log(userCredential.user?.uid ?? "");
        // add profile picture
        String url = await StorageMethod().storePicture(
          'profilePics',
          file,
          false,
        );
        // add user to database
        await _firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'username': username,
              'email': email,
              'bio': bio,
              'uid': userCredential.user!.uid,
              'followers': [],
              'following': [],
              'photoUrl': url,
            });
        res = "sucess";
      } else {
        res = 'No Fields are filled';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (e.code == 'weak-password') {
        res = 'Password is very weak.';
      } else {
        res = e.message ?? "Authentication error";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // log in user

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "sucess";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      res = e.message ?? "Authentication error ";
    } catch (e) {
      log(e.toString());
    }
    return res;
  }
}
