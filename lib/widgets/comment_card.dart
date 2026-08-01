import 'package:flutter/material.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/resources/firestore_methods.dart';
import 'package:insta/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> comment;
  final String postId;
  const CommentCard({super.key, required this.comment, required this.postId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.comment['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.comment['name']}  ',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        TextSpan(
                          text: '${widget.comment['text']}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.comment['datePublished'].toDate(),
                      ),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              LikeAnimation(
                isAnimating: isAnimating,
                onEnd: () {
                  setState(() {
                    isAnimating = false;
                  });
                },

                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likeComment(
                      commentId: widget.comment['commentId'],
                      uid: user!.uid,
                      likes: widget.comment['likes'],
                      postId: widget.postId,
                    );
                    setState(() {
                      isAnimating = true;
                    });
                  },
                  icon: const Icon(
                    Icons.favorite,
                    size: 16,
                  ),
                ),
              ),
              Text(widget.comment['likes'].length.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
