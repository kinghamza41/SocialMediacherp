// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps

import 'package:cherp_app/Comments/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        body: CommentCards(),
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
                  backgroundImage: NetworkImage(
                      "https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentDescController,
                      decoration: InputDecoration(
                          hintText: "Comment as ${userName}",
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
                        });
                      } else {
                        print('Text is empty');
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
