// ignore_for_file: non_constant_identifier_names, file_names, avoid_print, use_build_context_synchronously, prefer_const_constructors, unused_field, unnecessary_brace_in_string_interps, prefer_if_null_operators, unnecessary_null_comparison, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherp_app/services/userProfileServices.dart';
import 'package:cherp_app/widget/flutter_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  TextEditingController userNameAssignController = TextEditingController();
  TextEditingController fullNameAssignController = TextEditingController();
  TextEditingController profileBioAssignController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  String userName = '';
  dynamic userId;
  String userImg = '';
  String fullName = '';
  String userProfileBio = '';
  // File? profileImage;
  File? selectedImage;
  bool isLoading = true;
  String getSenderPostDocId = '';
  String getSenderPostCommentDocId = '';
  String getProfilePicForComments = '';

  final GlobalKey<FormState> _formKey = GlobalKey();

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
      if (snapshot.docs.isNotEmpty) {
        userName = snapshot.docs.first['userName'];
        userId = snapshot.docs.first['userId'];
        userImg = snapshot.docs.first['userImg'];
        fullName = snapshot.docs.first['fullName'];
        userProfileBio = snapshot.docs.first['userProfileBio'];

        setState(() {
          isLoading = false;
          print(userId);
        });
      }
    }
  }

  Future<void> getSenderPostId() async {
    if (user != null) {
      //  await FirebaseFirestore.instance.collection("users").get();
      final snapshot = await FirebaseFirestore.instance
          .collection("your_cherps")
          .where(
            "senderUserId",
            isEqualTo: user!.uid,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        getSenderPostDocId = snapshot.docs.first['postId'];

        // if (getSenderPostDocId != null) {
        //   getSenderPostCommentDetail(getSenderPostDocId);
        // }

        setState(() {
          //isLoading = false;
          print(getSenderPostDocId);
        });
      }
    }
  }

  // Future<void> getSenderPostCommentDetail(String getSenderPostDocId) async {
  //   if (user != null) {
  //     //  await FirebaseFirestore.instance.collection("users").get();
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("your_cherps")
  //         .doc('d1593778-db4f-4eda-b3ba-65a42f6cafab')
  //         .collection('comments')
  //         .get();
  //     // getSenderPostCommentDocId = snapshot;
  //     //  getProfilePicForComments = ;
  //     print(snapshot.toString());

  //     setState(() {
  //       //isLoading = false;
  //       // print(getSenderPostCommentDocId);
  //       // print(getProfilePicForComments);
  //     });
  //   }
  // }

  Future<void> chooseImage(type, BuildContext context) async {
    // ignore: prefer_typing_uninitialized_variables
    var image;

    if (type == "Gallery") {
      // ignore: prefer_equal_for_default_values
      // Navigator.of(context).pop();
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
      // Navigator.of(context).pop();
    } else if (type == "Camera") {
      // ignore: prefer_equal_for_default_values
      // Navigator.of(context).pop();
      image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
      // Navigator.of(context).pop();
    }
    if (image != null) {
      // Navigator.of(context).pop();
      setState(() {
        selectedImage = File(image.path);
        print(" photos link ${selectedImage}");
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserDetails();
    getSenderPostId();
    //getSenderPostCommentDetail();
    //print(selectedImage);
    print(userNameAssignController);
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
          // MyAvatar(),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: GestureDetector(
              onTap: () async {
                PermissionStatus galleryPermission =
                    await Permission.storage.request();
                print(galleryPermission);

                if (galleryPermission == PermissionStatus.granted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Pick Image:"),
                        actions: [
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text('Camera'),
                            onTap: () {
                              // chooseImage("camera");
                              Navigator.pop(context);

                              // selectImages("camera");
                              chooseImage("Camera", context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text('Gallery'),
                            onTap: () {
                              Navigator.pop(context);

                              chooseImage("Gallery", context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                if (galleryPermission == PermissionStatus.denied) {
                  DisplayFlutterToast("Please Allow Permission", context);
                }
                if (galleryPermission == PermissionStatus.permanentlyDenied) {
                  DisplayFlutterToast(
                      "Please Allow Permission For Further Usage", context);
                  openAppSettings();
                }
              },
              child: CircleAvatar(
                  // backgroundImage: ,
                  backgroundColor: Colors.transparent,

// MediaQuery.of(context).size.width * widget.aspect
                  // foregroundImage: const AssetImage("assets/Placeholder/P2.png"),
                  radius: 60,
                  child: ClipOval(
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              fit: BoxFit.fill,
                              // height: 10.h,
                              // width: 30.w,
                            )
                          : userImg == ''
                              ? Container()
                              : CachedNetworkImage(
                                  // width: 12.w,
                                  // height: 6.h,
                                  fit: BoxFit.fitHeight,
                                  placeholder: (context, url) => ColoredBox(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: CupertinoActivityIndicator(
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  imageUrl: userImg,
                                )
                      // : Image.asset('assets/Placeholder/P2.png'),
                      )
                  // : ClipOval(child: CachedNetworkImage(imageUrl: userImg)),
                  ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          text_field(
              context,
              userName.toString().isEmpty ? "Username" : userName,
              userNameController),
          my_spacing,
          text_field(
              context,
              fullName.toString().isEmpty ? "Full Name" : fullName,
              fullNameController),
          my_spacing,
          text_field(
              context,
              userProfileBio.toString().isEmpty
                  ? "Profile Bio"
                  : userProfileBio,
              profileBioController),
          my_spacing,
          GestureDetector(
            onTap: () async {
              if (userNameController.text.trim().isNotEmpty &&
                  fullNameController.text.trim().isNotEmpty &&
                  profileBioController.text.trim().isNotEmpty) {
                if (selectedImage == null &&
                    userImg == '' &&
                    userNameController.text.trim() != userName &&
                    fullNameController.text.trim() != fullName &&
                    profileBioController.text.trim() != userProfileBio) {
                  await updateOnlyFields(
                    context,
                    userNameController,
                    fullNameController,
                    profileBioController,
                    getSenderPostDocId,
                  );
                } else {
                  await updateUserProfileData(
                      context,
                      selectedImage,
                      userNameController,
                      fullNameController,
                      profileBioController,
                      getSenderPostDocId);
                }
              } else {
                DisplayFlutterToast('Your fields are empty', context);
              }
              print(userId);

              print("profile image ${selectedImage.toString()}");
            },
            child: Container(
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
