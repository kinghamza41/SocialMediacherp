// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_field, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCards extends StatefulWidget {
  dynamic snap;
  CommentCards({this.snap, super.key});

  @override
  State<CommentCards> createState() => _CommentCardsState();
}

class _CommentCardsState extends State<CommentCards> {
  bool replyContainer = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                radius: 18,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      widget.snap['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.snap['text'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // print('click');
                          setState(() {
                            replyContainer = true;
                            print(replyContainer);
                          });
                        },
                        child: Text(
                          'Reply',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        replyContainer
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          // controller: commentDescController,
                          decoration: InputDecoration(
                              hintText: "Write Something",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() async {
                        replyContainer = false;
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Text(
                          "Post",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
