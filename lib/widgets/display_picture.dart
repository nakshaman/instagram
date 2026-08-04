import 'package:flutter/material.dart';

class DisplayPicture extends StatefulWidget {
  final String image;
  const DisplayPicture({super.key, required this.image});

  @override
  State<DisplayPicture> createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
          ),
          Center(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.7,
              backgroundImage: NetworkImage(widget.image),
            ),
          ),
        ],
      ),
    );
  }
}
