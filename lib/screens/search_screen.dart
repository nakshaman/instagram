import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
          controller: searchController,
          decoration: InputDecoration(
            hint: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  size: 25,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Search',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: blueColor,
                width: 2.5,
              ),
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
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              user['photoUrl'],
                            ),
                          ),
                          title: Text(user['username']),
                        );
                      },
                    );
                  },
            )
          : const Text('Posts'),
    );
  }
}
