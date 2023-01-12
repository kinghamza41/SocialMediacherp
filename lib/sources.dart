// ignore_for_file: camel_case_types, constant_identifier_names, must_be_immutable, prefer_const_constructors, avoid_unnecessary_containers, avoid_print, non_constant_identifier_names

import 'package:cherp_app/Comments/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeral/numeral.dart';

class sources {
  static const icon_main = "assets/Icon/main_transparent.svg";
  static const background = "assets/background_dark.png";
  static const font_style = GoogleFonts.outfit;

  static const avatar_01 = "assets/Placeholder/P1.png";
  static const avatar_02 = "assets/Placeholder/P2.png";

  static const image_01 = "assets/Placeholder/Image1.png";

  static var is_dark = true;
  //static var is_dark = ThemeMode.system == ThemeMode.dark;

  static const color_dark = Colors.black;
  static const color_light = Colors.white;

  static final color_selected = is_dark ? color_dark : color_light;
  static final color_TheOther = is_dark ? color_light : color_dark;

  static const background_dark = "assets/background_dark.png";
  static const background_light = "assets/background_light.png";

  static const background_profile_dark = "assets/background_profile_dark.png";
  static const background_profile_light = "assets/background_profile_light.png";

  static const icon_video = "assets/Icon/add_video.svg";
  static const icon_photo = "assets/Icon/add_photo.svg";
  static const icon_audio = "assets/Icon/add_audio.svg";
  static const icon_phone = "assets/Icon/add_phone.svg";
}

class TheButton extends StatefulWidget {
  const TheButton(
      {required this.text, this.aspect = 0.07, this.onPressed, super.key});

  final double aspect;
  final VoidCallback? onPressed;
  final String text;

  @override
  State<TheButton> createState() => _TheButtonState();
}

class _TheButtonState extends State<TheButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        // _isPressed should be true when the button is pressed, but set to false when the button is released.
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() {
          _isPressed = false;
          widget.onPressed?.call();
        }),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isPressed ? sources.color_TheOther : Colors.yellow,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * widget.aspect,
          ),
          child: Text(
            widget.text,
            style: sources.font_style(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      );
}

class DarkOne extends StatelessWidget {
  const DarkOne({this.profile = false, required this.child, Key? key})
      : super(key: key);

  final Widget child;
  final bool profile;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                sources.is_dark
                    ? profile
                        ? sources.background_profile_dark
                        : sources.background_dark
                    : profile
                        ? sources.background_profile_light
                        : sources.background_light,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        ),
      );
}

class TheCard extends StatefulWidget {
  String? senderUserName;
  int cherpLikes;
  String? documentId;
  List? cherpLikeUserList;
  int? totalcomments;

  String? targetUserName;
  TheCard(this.senderUserName, this.cherpLikes, this.documentId,
      this.cherpLikeUserList, this.totalcomments, this.targetUserName,
      // this.cherpLikeUserList,
      {Key? key})
      : super(key: key);

  @override
  State<TheCard> createState() => _TheCardState();
}

class _TheCardState extends State<TheCard> {
  User? user;
  bool? isLiked = false;
  // List cherpUserList = [];
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // print(senderUserName);
    user = FirebaseAuth.instance.currentUser;
    print("the card  ${widget.cherpLikeUserList.toString()}");
    // cherpUserList = widget.cherpLikeUserList!;
    // print("val $cherpUserList");
// user =FirebaseAuth.instance.currentUser;
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    Widget getAvatar({
      required String path,
      required String name,
    }) =>
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(path),
                      radius: 25,
                    ),
                  ),
                ),
              ),
              Text(
                // widget.senderUserName.toString(),
                name,
                style: sources.font_style(
                  color: sources.color_TheOther,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              )
            ],
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: sources.is_dark
            ? sources.color_dark.withOpacity(0.2)
            : sources.color_light,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.025,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              getAvatar(
                  path: sources.avatar_01,
                  name: widget.senderUserName.toString()),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_circle_right_rounded,
                    color: Colors.yellow),
              ), // Arrow
              getAvatar(
                  path: sources.avatar_02,
                  name: widget.targetUserName.toString()),
            ],
          ), // Avatars
          Text(
            "Here is the sample text, which is going to be replaced with the actual "
            "tweet. This is just a placeholder for now. I am going to further design "
            "the application.",
            style: sources.font_style(
              color: sources.color_TheOther.withOpacity(0.8),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          //  // Text
          // Text(
          //   "Data",
          //   style: TextStyle(fontSize: 20, color: Colors.white),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(sources.image_01,
                  width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
          ), // Image
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              GestureDetector(
                onTap: () async {
                  print(widget.cherpLikes);
                  if (widget.cherpLikeUserList!.contains(user!.uid)) {
                    await FirebaseFirestore.instance
                        .collection("your_cherps")
                        .doc(widget.documentId)
                        .update({
                      'cherpLikes': widget.cherpLikes - 1,
                      'cherpLikeUserList': FieldValue.arrayRemove([user?.uid]),
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection("your_cherps")
                        .doc(widget.documentId)
                        .update({
                      'cherpLikes': widget.cherpLikes + 1,
                      'cherpLikeUserList': [user!.uid],
                    });
                  }
                },
                child: Container(
                  // color: Colors.amber,
                  child: Row(
                    children: [
                      widget.cherpLikeUserList!.contains(user!.uid)
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        Numeral(widget.cherpLikes).format().toString(),
                        style: sources.font_style(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  print(widget.documentId.toString());
                  Get.to(() => MyComments(), arguments: {
                    'postDocumentId': widget.documentId.toString(),
                  });
                },
                child: Container(
                  // color: Colors.blue,
                  child: Row(
                    children: [
                      Icon(Icons.comment, color: Colors.white),
                      const SizedBox(width: 5),
                      widget.totalcomments == 0
                          ? Text('')
                          : Text(
                              Numeral(int.parse(
                                      widget.totalcomments.toString()))
                                  .format()
                                  .toString(),
                              style: sources.font_style(
                                color: sources.color_TheOther,
                                fontSize: 15,
                              ),
                            ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 10),
              // Icon(Icons.message_rounded, color: sources.color_TheOther),

              // Icons
              // const Icon(Icons.share, color: Colors.white),
            ],
          ), // Icons
        ],
      ),
    );
  }
}
