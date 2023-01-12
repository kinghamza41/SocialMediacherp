// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, unnecessary_null_comparison, prefer_if_null_operators

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherp_app/Comments/comment_card.dart';
import 'package:cherp_app/widget/flutter_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class MyComments extends StatefulWidget {
  const MyComments({super.key});

  @override
  State<MyComments> createState() => _MyCommentsState();
}

class _MyCommentsState extends State<MyComments> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userId;
  String? userNumber;
  String? userImg;
  String? postId;
  int? totalComments;
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

  Future<void> getCherpDetails() async {
    if (user != null) {
      //  await FirebaseFirestore.instance.collection("users").get();
      final snapshot = await FirebaseFirestore.instance
          .collection("your_cherps")
          .where(
            "senderUserId",
            isEqualTo: user!.uid,
          )
          .get();
      postId = snapshot.docs.first['postId'];
      // userId = snapshot.docs.first['userId'];
      // userNumber = snapshot.docs.first['phoneNumber'];
      // userImg = snapshot.docs.first['userImg'];

      setState(() {
        print(postId);
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getSenderUserDetails();
    getCherpDetails();
  }

  // Future<String> postComment() async{

  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("your_cherps")
              .doc(postId)
              .collection('comments')
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
              print(snapshot.data!.docs.length);
              totalComments = snapshot.data!.docs.length;
              return ListView.builder(
                itemCount: totalComments,
                itemBuilder: (context, index) {
                  return CommentCards(
                    snap: snapshot.data!.docs[index].data(),
                  );
                },
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          hintText:
                              "Comment as ${userName == null ? 'UserName' : userName}",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() async {
                    String commentId = Uuid().v4();

                    try {
                      if (commentDescController.text.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection("your_cherps")
                            .doc(postId)
                            .collection("comments")
                            .doc(commentId)
                            .set({
                          "profilePic": userImg,
                          'name': userName,
                          'uid': userId,
                          'text': commentDescController.text.toString(),
                          'datePublished': DateTime.now(),
                          'commentId': commentId,
                        }).then(
                          (value) => commentDescController.clear(),
                        );

                        await FirebaseFirestore.instance
                            .collection("your_cherps")
                            .doc(postId)
                            .update({
                          'cherpTotalComment': totalComments,
                        });
                      } else {
                        DisplayFlutterToast("Please write comment", context);
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  }),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Text(
                      "Post",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
