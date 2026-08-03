import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          cursorColor: primaryColor,
          showCursor: true,
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(78, 245, 245, 245),
            hint: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  size: 25,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Search',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
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
                    return ListView.builder(
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
                      posts.data!.docs.length,
                      (index) {
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: index % 7 == 0 ? 2 : 1,
                          child: Image.network(
                            posts.data!.docs[index]['postUrl'],
                            fit: BoxFit.cover,
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
