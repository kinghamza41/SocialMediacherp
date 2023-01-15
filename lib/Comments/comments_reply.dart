// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, unnecessary_null_comparison, prefer_if_null_operators

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherp_app/Comments/comment_card.dart';
import 'package:cherp_app/widget/flutter_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CommentsReplyScreen extends StatefulWidget {
  const CommentsReplyScreen({super.key});

  @override
  State<CommentsReplyScreen> createState() => _CommentsReplyScreenState();
}

class _CommentsReplyScreenState extends State<CommentsReplyScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userId;
  String? userNumber;
  String? userImg;
  String? postId;
  int? totalComments;
  String? getPostCommentId;
  String? getPostId;
  bool isLoading = true;
  TextEditingController commentDescController = TextEditingController();

  Future<void> getSenderUserDetails() async {
    if (user != null) {
      //  await FirebaseFirestore.instance.collection("users").get();
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where(
            "userId",
            isEqualTo: user!.uid,
          )
          .get();
      userName = snapshot.docs.first['userName'];
      userId = snapshot.docs.first['userId'];
      userNumber = snapshot.docs.first['phoneNumber'];
      userImg = snapshot.docs.first['userImg'];

      setState(() {
        print(userId);
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getSenderUserDetails();
    // print(postId);
    getPostCommentId = Get.arguments['commentId'];
    getPostId = Get.arguments['postId'];
    isLoading = false;
    //getCherpDetails(getPostDocumentId);

    print('postCommentId  ${Get.arguments['commentId']}');
  }

  // Future<String> postComment() async{

  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_dark.png'
                // sources.is_dark
                //     ? profile
                //         ? sources.background_profile_dark
                //         : sources.background_dark
                //     : profile
                //         ? sources.background_profile_light
                //         : sources.background_light,
                ),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("your_cherps")
                    .doc(getPostId)
                    .collection('comments')
                    .doc(getPostCommentId)
                    .collection('replies')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No data found"),
                    );
                  }
                  if (snapshot != null && snapshot.data != null) {
                    print('length ${snapshot.data!.docs.length}');
                    totalComments = snapshot.data!.docs.length;
                    return ListView.builder(
                      itemCount: totalComments,
                      itemBuilder: (context, index) {
                        return
                            //  Container(
                            //   child: Text(
                            //     'val',
                            //     style: TextStyle(color: Colors.black),
                            //   ),
                            // );
                            CommentReplyCards(
                          snap: snapshot.data!.docs[index].data(),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_dark.png'
                  // sources.is_dark
                  //     ? profile
                  //         ? sources.background_profile_dark
                  //         : sources.background_dark
                  //     : profile
                  //         ? sources.background_profile_light
                  //         : sources.background_light,
                  ),
              fit: BoxFit.cover,
            ),
          ),
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CircleAvatar(
                // backgroundImage:  ,
                child: ClipOval(
                  child: CachedNetworkImage(
                    // width: 12.w,
                    // height: 6.h,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => ColoredBox(
                      color: Colors.transparent,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    imageUrl: '$userImg',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentDescController,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        hintText:
                            "Reply as ${userName == null ? 'UserName' : userName}",
                        border: InputBorder.none),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (() async {
                  String commentReplyId = Uuid().v4();

                  try {
                    if (commentDescController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("your_cherps")
                          .doc(getPostId)
                          .collection("comments")
                          .doc(getPostCommentId)
                          .collection('replies')
                          .doc(commentReplyId)
                          .set({
                        "profilePic": userImg,
                        'name': userName,
                        'uid': userId,
                        'replyText': commentDescController.text.toString(),
                        'datePublished': DateTime.now(),
                        'postId': getPostId,
                        'replyId': commentReplyId,
                        'commentId': getPostCommentId,
                      }).then(
                        (value) => commentDescController.clear(),
                      );

                      // await FirebaseFirestore.instance
                      //     .collection("your_cherps")
                      //     .doc(getPostDocumentId)
                      //     .update({
                      //   'cherpTotalComment': totalComments,
                      // });
                    } else {
                      DisplayFlutterToast("Please write Reply", context);
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    "Post",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
