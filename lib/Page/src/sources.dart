// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_const_constructors, unnecessary_null_comparison, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../sources.dart';

class settings_info {
  static const name = "Bruce Wayne";
  static const username = "@i_am_batman";
  static const biography =
      "Your profile bio information along with status information will go here. You can also add a link to your website here, along with your social media links.";
}

final field_border_style = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(
    color: Colors.white.withOpacity(0.7),
  ),
);

Widget text_field(BuildContext context, String label,
        [TextEditingController? controller]) =>
    TextFormField(
      style: sources.font_style(
        color: Colors.white,
        // fontSize: 18,
        fontSize: MediaQuery.of(context).size.width * 0.04,
      ),
      controller: controller,
      maxLines: null,
      cursorColor: Colors.white.withOpacity(0.7),
      decoration: InputDecoration(
        // Set some default text
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        contentPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        labelText: label,

        labelStyle: sources.font_style(
          color: Colors.white.withOpacity(0.7),
          fontSize: 18,
        ),
        enabledBorder: field_border_style,
        focusedBorder: field_border_style,
      ),
    );

class MyAvatar extends StatelessWidget {
  const MyAvatar({this.aspect = 0.2, Key? key}) : super(key: key);

  final double aspect;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          foregroundImage: const AssetImage("assets/Placeholder/P2.png"),
          radius: MediaQuery.of(context).size.width * aspect,
        ),
      );
}

class Tweets extends StatefulWidget {
  const Tweets({Key? key}) : super(key: key);

  @override
  State<Tweets> createState() => _TweetsState();
}

class _TweetsState extends State<Tweets> {
  String? senderUserName;
  String? senderUserId;
  String? senderUserNumber;
  String? senderUserImg;
  String? targetUserName;
  String? targetUserId;
  String? targetUserNumber;
  String? targetUserImg;
  String? cherpDesc;
  String? postImg;
  int? cherpLikes;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("your_cherps")
            .orderBy('createdAt', descending: true)
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

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                itemBuilder: (context, index) {
                  var documentId = snapshot.data!.docs[index].id;
                  print('documentId $documentId');
                  senderUserName = snapshot.data!.docs[index]['senderUserName'];

                  senderUserImg = snapshot.data!.docs[index]['senderUserImg'];
                  cherpDesc = snapshot.data!.docs[index]['cherpDesc'];
                  targetUserName = snapshot.data!.docs[index]['targetUserName'];
                  targetUserImg = snapshot.data!.docs[index]['targetUserImg'];
                  postImg = snapshot.data!.docs[index]['postImg'];
                  cherpLikes = snapshot.data!.docs[index]['cherpLikes'];
                  List cherpLikeUserList =
                      snapshot.data!.docs[index]['cherpLikeUserList'];
                  return TheCard(senderUserName, cherpLikes!, documentId,
                      cherpLikeUserList);
                });
          }
          return Container();
        });
  }
}
