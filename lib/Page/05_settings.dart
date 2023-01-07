// ignore_for_file: non_constant_identifier_names, file_names, avoid_print, use_build_context_synchronously

import 'package:cherp_app/utils/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'src/sources.dart';
import '../sources.dart';

class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  static final text_controller =
      List.generate(3, (index) => TextEditingController());

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  TextEditingController profileBioController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  dynamic userName;
  dynamic userId;

  Future<void> getUserDetails() async {
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
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final my_spacing = SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );

    return DarkOne(
      child: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.1,
        ),
        children: [
          const MyAvatar(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          text_field(context, "Username", userNameController),
          my_spacing,
          text_field(context, "Full Name", fullNameController),
          my_spacing,
          text_field(context, "Profile Bio", profileBioController),
          my_spacing,
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: MediaQuery.of(context).size.width * 0.07,
            ),
            child: TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return ProgressDialog(
                        message: "Please Wait..",
                      );
                    });
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .update({
                  'userName': userNameController.text.toString(),
                  'userImg': "",
                  'userProfileBio': profileBioController.text.toString(),
                  'fullName': fullNameController.text.toString(),
                });
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: sources.font_style(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
