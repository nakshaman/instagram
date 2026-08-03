import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/resources/auth_methods.dart';
import 'package:insta/resources/firestore_methods.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> user = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // userData
      DocumentSnapshot<Map<String, dynamic>> userSnap = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.uid)
          .get();
      user = userSnap.data()!;
      // post length
      var userPost = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          ) // my code
          .get();
      postLength = userPost.docs.length;
      // followers , following
      followers = user['followers'].length;
      following = user['following'].length;

      // isFollowing
      isFollowing = user['followers'].contains(
        FirebaseAuth.instance.currentUser!.uid,
      );
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                user['username'] ?? "",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              user['photoUrl'] ?? "",
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStats(postLength, 'posts', context),
                                    buildStats(followers, 'followers', context),
                                    buildStats(following, 'following', context),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().logout();
                                            },
                                          )
                                        : isFollowing
                                        ? FollowButton(
                                            backgroundColor: primaryColor,
                                            borderColor: Colors.grey,
                                            text: 'unfollow',
                                            textColor: blackColor,
                                            function: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    user['uid'],
                                                  );
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            backgroundColor: Colors.blue,
                                            borderColor: Colors.blue,
                                            text: 'follow',
                                            textColor: primaryColor,
                                            function: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    user['uid'],
                                                  );
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          user['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          user['bio'],
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: ((context, posts) {
                    if (posts.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: primaryColor,
                        ),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (posts.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (posts.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              snap['postUrl'],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
  }
}

Column buildStats(int num, String label, BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            // color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}
