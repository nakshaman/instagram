import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/resources/firestore_methods.dart';
import 'package:insta/screens/comment_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    log('Build called');
    // log(widget.post.toString());

    final user = Provider.of<UserProvider>(context).getUser!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post['username'],
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: mobileBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (context) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedDelete01,
                                  ),
                                  title: const Text(
                                    "Delete Post",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);

                                    final res = await FirestoreMethods()
                                        .deletePost(
                                          widget.post['postId'],
                                        );
                                    showSnackBar(
                                      res,
                                      context,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMenu01,
                  ),
                ),
              ],
            ),
          ),

          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                postId: widget.post['postId'],
                likes: widget.post['likes'],
                uid: currentUserUid,
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: widget.post['postId'],
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.post['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 120,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Like Comment Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeAnimation(
                    isAnimating: widget.post['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                      onPressed: () async {
                        await FirestoreMethods().likePost(
                          postId: widget.post['postId'],
                          likes: widget.post['likes'],
                          uid: currentUserUid,
                        );
                      },
                      icon: widget.post['likes'].contains(user.uid)
                          ? const Icon(
                              Icons.favorite_sharp,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            postId: widget.post['postId'],
                          ),
                        ),
                      );
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedComment01,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const HugeIcon(icon: HugeIcons.strokeRoundedTelegram),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedBookmarkAdd02,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.post['likes'].length} likes',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.post['username'],
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        TextSpan(
                          text: '  ${widget.post['description']}',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Comments
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          postId: widget.post['postId'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      widget.post['commentCount'] == 0
                          ? 'No comments yet'
                          : widget.post['commentCount'] == 1
                          ? 'View 1 comment'
                          : 'View all ${widget.post['commentCount']} comments',
                    ),
                  ),
                ),
                // Date
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.post['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
