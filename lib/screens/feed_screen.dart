import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:insta/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > webScreenSize;
    final currentSize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: isWeb ? webBackgroundColor : mobileBackgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder:
            (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              // error
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                );
              }
              // doesn't have data
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Posts"),
                );
              }
              // has data
              return CustomScrollView(
                slivers: [
                  if (!isWeb)
                    SliverAppBar(
                      expandedHeight: 70,
                      title: SvgPicture.asset(
                        'assets/ic_instagram.svg',
                        color: primaryColor,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: SvgPicture.asset(
                            'assets/message.svg',
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 70,
                      left: isWeb ? currentSize * 0.3 : 0,
                      right: isWeb ? currentSize * 0.3 : 0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PostCard(
                            post: snapshot.data!.docs[index].data(),
                          );
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }
}
