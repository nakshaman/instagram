import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/resources/storage_method.dart';
import 'package:insta/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // user detail
  Future<model.User> getUserDetail() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap;
    do {
      snap = await _firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (!snap.exists) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } while (!snap.exists);
    return model.User.fromSnap(snap);
  }

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

        model.User user = model.User(
          email: email,
          uid: userCredential.user!.uid,
          photoUrl: url,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );
        await _firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        log("Firestore user document created");
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
    log("Login button pressed");
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
      if (e.code == "user-not-found") {
        res = 'User not found';
      } else if (e.code == "wrong-password") {
        res = 'Wrong password';
      }
    } catch (e) {
      log(e.toString());
    }
    log("Firebase returned: $res");
    return res;
  }

  //logout

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
