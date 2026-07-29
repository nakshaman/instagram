import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/utils/colors.dart';

Future<Uint8List?> pickImage(ImageSource imageSource) async {
  final imagePicker = ImagePicker();
  final pickedImage = await imagePicker.pickImage(
    source: imageSource,
    imageQuality: 50,
  );
  if (pickedImage != null) {
    return pickedImage.readAsBytes();
  }
  log('No Image Selected');
  return null;
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: blackColor,
    ),
  );
}
