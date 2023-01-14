// ignore_for_file: file_names, prefer_const_constructors, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, duplicate_ignore, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:sizer/sizer.dart';
import 'src/sources.dart';
import '../sources.dart';

class MySearch extends StatefulWidget {
  const MySearch({Key? key}) : super(key: key);

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
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
  var totalComments;
  TextEditingController searchCorntroller = TextEditingController();
  late CallbackAction onChange;
  String isSearch = '';
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    searchCorntroller.dispose();
  }

  @override
  Widget build(BuildContext context) => DarkOne(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: TextFormField(
                style: sources.font_style(
                  color: Colors.white,
                  // fontSize: 18,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
                onChanged: (value) {
                  setState(() {
                    value = searchCorntroller.text;
                  });
                },
                controller: searchCorntroller,
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
                  labelText: "Search",

                  labelStyle: sources.font_style(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                  enabledBorder: field_border_style,
                  focusedBorder: field_border_style,
                ),
              ),
            ),
            Expanded(child: SearchTweets(searchCorntroller)),
          ],
        ),
      );
}


