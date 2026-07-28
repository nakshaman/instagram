import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  Future<String> storePicture(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    final Reference ref = await _storage
        .ref()
        .child(childName)
        .child(_auth.currentUser!.uid);
    UploadTask task = ref.putData(file);
    TaskSnapshot snap = await task;
    String url = await snap.ref.getDownloadURL();
    log(url);
    return url;
  }
}
