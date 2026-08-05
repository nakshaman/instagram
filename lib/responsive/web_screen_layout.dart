import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:insta/models/user.dart' as model;
import 'package:insta/provider/user_provider.dart';
import 'package:insta/screens/add_post_screen.dart';
import 'package:insta/screens/feed_screen.dart';
import 'package:insta/screens/profile_screen.dart';
import 'package:insta/screens/search_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryColor,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
            ),
          ),
          centerTitle: false,
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.80),
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: GNav(
                selectedIndex: currentPageIndex,
                gap: 10,
                onTabChange: onTabChange,
                tabBorderRadius: 20,
                tabBackgroundColor: Colors.grey.shade800,
                activeColor: Colors.white,
                color: Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                curve: Curves.easeOutQuad,
                tabs: const [
                  GButton(
                    icon: Icons.circle,
                    leading: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
                  ),
                  GButton(
                    icon: Icons.circle,
                    leading: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
                  ),
                  GButton(
                    icon: Icons.circle,
                    leading: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                  ),
                  GButton(
                    icon: Icons.circle,
                    leading: HugeIcon(icon: HugeIcons.strokeRoundedFavourite),
                  ),
                  GButton(
                    icon: Icons.circle,
                    leading: HugeIcon(icon: HugeIcons.strokeRoundedUser03),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const Center(
            child: Text('Favorite'),
          ),
          ProfileScreen(
            uid: user.uid,
          ),
        ],
      ),
    );
  }
}
