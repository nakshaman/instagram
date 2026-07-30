import 'package:flutter/material.dart';
import 'package:insta/screens/add_post_screen.dart';

const webScreenSize = 600;

const List<Widget> homeScreenItems = [
  Center(
    child: Text('Home'),
  ),
  Center(
    child: Text('Search'),
  ),
  AddPostScreen(),
  Center(
    child: Text('Favorite'),
  ),
  Center(
    child: Text('Profile'),
  ),
];
