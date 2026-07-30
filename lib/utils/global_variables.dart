import 'package:flutter/material.dart';
import 'package:insta/screens/add_post_screen.dart';
import 'package:insta/screens/feed_screen.dart';

const webScreenSize = 600;

const List<Widget> homeScreenItems = [
  FeedScreen(),
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
