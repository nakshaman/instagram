import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:insta/screens/notification_post_detail.dart';
import 'package:insta/screens/profile_screen.dart';
import 'package:insta/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      isShowUsers = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: TextFormField(
              cursorColor: primaryColor,
              showCursor: true,
              controller: searchController,
              onChanged: (value) {
                if (value.trim().isEmpty && isShowUsers) {
                  setState(() {
                    isShowUsers = false;
                  });
                }
              },
              decoration: InputDecoration(
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 36, // Adjust padding area around the icon
                  minHeight: 36,
                ),
                filled: true,
                fillColor: const Color.fromARGB(78, 245, 245, 245),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 6, right: 6),
                  child: HugeIcon(
                    size: 8,
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: Colors.white,
                  ),
                ),
                suffixIcon: isShowUsers || searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: clearSearch,
                        icon: const HugeIcon(
                          color: primaryColor,
                          icon: HugeIcons.strokeRoundedCancel01,
                        ),
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onFieldSubmitted: (String search) {
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text.trim(),
                  )
                  .get(),
              builder:
                  (
                    context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> users,
                  ) {
                    if (users.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    if (users.hasError) {
                      return const Center(
                        child: Text('Something went wrong. Please try again.'),
                      );
                    }
                    if (!users.hasData || users.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No user found.'),
                      );
                    }
                    final docs = users.data!.docs;
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final user = docs[index].data();
                            return InkWell(
                              onTap: () {
                                log(user['username']);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(uid: user['uid']),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                    user['photoUrl'],
                                  ),
                                ),
                                title: Text(user['username']),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, posts) {
                if (posts.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
                if (posts.hasError) {
                  return const Center(
                    child: Text('Something went wrong.'),
                  );
                }
                if (!posts.hasData || posts.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Post yet.'),
                  );
                }
                final docs = posts.data!.docs;

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 3,
                    children: List.generate(
                      docs.length,
                      (index) {
                        final postData = docs[index].data();
                        final String postId = postData['postId'];
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: index % 7 == 0 ? 2 : 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NotificationPostDetail(
                                    postId: postId,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              postData['postUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
