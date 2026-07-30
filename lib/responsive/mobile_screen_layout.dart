import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:insta/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int currentPageIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onTabChange(int index) {
    setState(() {
      currentPageIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  final List<Widget> _pages = homeScreenItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // to stop swipe
        children: _pages,
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
            selectedIndex: currentPageIndex,
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
                leading: HugeIcon(icon: HugeIcons.strokeRoundedUser03),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
