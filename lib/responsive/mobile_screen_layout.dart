import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late String username = "";
  var currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    log(snapshot.data().toString());
    setState(() {
      username = (snapshot.data() as Map<String, dynamic>)['username'];
    });
  }

  void onTabChange(int index) {
    setState(() {
      currentPageIndex = index;
      log(index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Hello world'),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: GNav(
            gap: 5,
            onTabChange: onTabChange,
            tabBorderRadius: 20,
            tabBackgroundColor: Colors.grey.shade900,
            activeColor: Colors.white,
            color: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            curve: Curves.easeOutQuad,
            tabs: const [
              GButton(
                icon: Icons.circle,
                // text: 'Home',
                leading: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
              ),
              GButton(
                icon: Icons.circle,
                // text: 'Message',
                leading: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
              ),
              GButton(
                icon: Icons.circle,
                // text: 'Profile',
                leading: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
              ),
              GButton(
                icon: Icons.circle,
                // text: 'Profile',
                leading: HugeIcon(icon: HugeIcons.strokeRoundedFavourite),
              ),
              GButton(
                icon: Icons.circle,
                // text: 'Profile',
                leading: HugeIcon(icon: HugeIcons.strokeRoundedUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
