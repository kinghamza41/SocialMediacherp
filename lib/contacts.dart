// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, library_private_types_in_public_api, avoid_print, unnecessary_null_comparison, prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'dart:developer';
import 'dart:io';

import 'package:cherp_app/Page/send_cherp_screen.dart';
import 'package:cherp_app/main.dart';
import 'package:cherp_app/sources.dart';
import 'package:cherp_app/widget/flutter_toast.dart';
import 'package:cherp_app/widget/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'Page/src/sources.dart';

void main() => runApp(FlutterContactsExample());

class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? senderUserName;
  String? senderUserId;
  String? senderUserNumber;
  String? senderUserImg;
  String? targetUserName = '';
  String? targetUserId = '';
  String? targetUserNumber = '';
  String? targetUserImg = '';
  @override
  void initState() {
    super.initState();
    _fetchContacts();
    getSenderUserDetails();
    // getTargetUserDetails();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

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
      senderUserName = snapshot.docs.first['userName'];
      senderUserId = snapshot.docs.first['userId'];
      senderUserNumber = snapshot.docs.first['phoneNumber'];
      senderUserImg = snapshot.docs.first['userImg'];

      setState(() {
        print(senderUserId);
      });
    }
  }

  Future<void> getTargetUserDetails(String targetUserPhoneNumber) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where(
            "phoneNumber",
            isEqualTo: targetUserPhoneNumber,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        targetUserName = snapshot.docs.first['userName'];
        targetUserId = snapshot.docs.first['userId'];
        targetUserNumber = snapshot.docs.first['phoneNumber'];
        targetUserImg = snapshot.docs.first['userImg'];
        print(targetUserPhoneNumber);
        //   print(snapshot.docs.first['phoneNumber']);
      } else if (snapshot.docs.isEmpty) {
        ///  call twillio service todo
        DisplayFlutterToast('Not exist', context);
      }
      print(snapshot.docs.first['phoneNumber']);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          // appBar: AppBar(title: Text('flutter_contacts_example')),
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
        child: _body(),
      ));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(
              _contacts![i].displayName,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              final fullContact =
                  await FlutterContacts.getContact(_contacts![i].id);
              // String v = fullContact!.phones.first.number;

              await Get.offAll(() => ContactPage(fullContact!), arguments: {
                'senderUserId': senderUserId,
                'senderUserName': senderUserName,
                'senderUserImg': senderUserImg,
                'senderUserNumber': senderUserNumber,
                // 'fullContact': v,
                // 'targetUserId': targetUserId,
                // 'targetUserName': targetUserName,
                // 'targetUserImg': targetUserImg,
                // 'targetUserNumber': targetUserNumber,
              });
              // await Navigator.of(context).push(
              //     MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
            }));
  }
}

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String? targetUserName = '';
  String? targetUserId = '';
  String? targetUserNumber = '';
  String? targetUserImg = '';
  String? senderUserName;
  String? senderUserId;
  String? senderUserNumber;
  String? senderUserImg;
  File? selectedImage;

  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController cherpDescController = TextEditingController();

  Future<void> getTargetUserDetails(String targetUserPhoneNumber) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where(
            "phoneNumber",
            isEqualTo: targetUserPhoneNumber,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        targetUserName = snapshot.docs.first['userName'];
        targetUserId = snapshot.docs.first['userId'];
        targetUserNumber = snapshot.docs.first['phoneNumber'];
        targetUserImg = snapshot.docs.first['userImg'];
        print(targetUserNumber);
        //   print(snapshot.docs.first['phoneNumber']);
      } else if (snapshot.docs.isEmpty) {
        ///  call twillio service todo
        DisplayFlutterToast('Not exist', context);
      }
      print(snapshot.docs.first['phoneNumber']);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

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
    // targetUserNumber=
    // getTargetUserDetails(widget.contact.phones.first.number);
    // print('targetUser $targetUserNumber');

    senderUserId = Get.arguments['senderUserId'];
    senderUserName = Get.arguments['senderUserName'];

    senderUserNumber = Get.arguments['senderUserNumber'];

    senderUserImg = Get.arguments['senderUserImg'];
  }

  @override
  Widget build(BuildContext context) {
    final accent_color = sources.is_dark ? Colors.yellow : Colors.black;

    Widget bottomLogo(String path) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            path,
            height: MediaQuery.of(context).size.height * 0.025,
            color: accent_color,
          ),
        );

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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ), // 3% Empty screen height
            Container(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () async {
                  // sending cherp to contact
                  await getTargetUserDetails(
                      widget.contact.phones.first.number);
                  print(targetUserNumber);
                  print(senderUserId);
                  if (cherpDescController.text.isNotEmpty &&
                      selectedImage != null) {
                    if (widget.contact.phones.first.number ==
                        targetUserNumber) {
                      String? postId = Uuid().v4();
                      int totalComments = 0;
                      String? imageurl;
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return ProgressDialog(
                              message: "Please Wait..",
                            );
                          });
                      try {
                        CollectionReference users =
                            FirebaseFirestore.instance.collection('users');
                        // User? user = FirebaseAuth.instance.currentUser;
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child("userPostImages")
                            .child(DateTime.now().toString() + ".jpg");

                        await ref.putFile(selectedImage!);
                        imageurl = await ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection("your_cherps")
                            .doc(postId)
                            .set(
                          {
                            'senderUserId': senderUserId,
                            'createdAt': DateTime.now(),
                            'senderUserName': senderUserName,
                            'senderUserNumber': senderUserNumber,
                            'senderUserImg': senderUserImg,
                            'postImg': imageurl,
                            'targetUserName': targetUserName,
                            'targetUserId': targetUserId,
                            'targetUserImg': targetUserImg,
                            'cherpTotalComment': totalComments,
                            'cherpLikeUserList': [],
                            'postId': postId,
                            'cherpLikes': 0,
                            'cherpDesc': cherpDescController.text,
                            'targetUserNumber':
                                widget.contact.phones.first.number,
                          },
                        ).then((value) => DisplayFlutterToast(
                                'Post has been uploaded', context));
                        Navigator.pop(context);
                        Get.off(() => TheMain());
                      } catch (e) {
                        print(e);
                      }
                    }
                  } else if (selectedImage == null) {
                    DisplayFlutterToast("Please select image", context);
                  } else if (cherpDescController.text.isEmpty) {
                    DisplayFlutterToast("Write Description", context);
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.yellow.withOpacity(0.05),
                  foregroundColor: Colors.yellow,
                  side: const BorderSide(
                    color: Colors.yellow,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: Text(
                        "Cherp",
                        style: sources.font_style(
                          color: Colors.yellow,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: SvgPicture.asset(
                        sources.icon_main,
                        height: MediaQuery.of(context).size.height * 0.025,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ), // Cherp button
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.04,
                ),
                alignment: Alignment.topLeft,
                child: TextField(
                  cursorColor: accent_color,
                  controller: cherpDescController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    icon: const MyAvatar(aspect: 0.1),
                    hintText: "What's Happening?",
                    hintStyle: sources.font_style(
                      color: sources.color_TheOther.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  style: sources.font_style(
                    color: sources.color_TheOther,
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                ),
              ),
            ), // What's Happening
            selectedImage != null
                ? Container(
                    height: 200,
                    child: Image.file(
                      selectedImage!,
                      fit: BoxFit.contain,
                      // height: 00,
                      // width: double.infinity,
                    ),
                  )
                : Spacer(),
            Row(
              children: [
                bottomLogo(sources.icon_phone),
                Expanded(
                  flex: 3,
                  child: Text(
                    // widget.contact.phones.first.number?

                    // Get.arguments['fullContact']?
                    '${widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : '(none)'}',

                    // : Get.arguments['fullContact'],
                    textAlign: TextAlign.left,
                    style: sources.font_style(
                      color: sources.color_TheOther.withOpacity(0.5),
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                GestureDetector(
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
                    if (galleryPermission ==
                        PermissionStatus.permanentlyDenied) {
                      DisplayFlutterToast(
                          "Please Allow Permission For Further Usage", context);
                      openAppSettings();
                    }
                  },
                  child: bottomLogo(sources.icon_photo),
                  // child: SvgPicture.asset(
                  //   sources.icon_photo,
                  //   height: MediaQuery.of(context).size.height * 0.025,
                  //   color: accent_color,
                  // ),
                ),
                bottomLogo(sources.icon_video),
                bottomLogo(sources.icon_audio),
              ],
            ), // Select Contact, Photo, Video, Audio
          ],
        ),
      ),
    );
    // appBar: AppBar(title: Text(widget.contact.displayName)),
    // body: Column(children: [
    //   Text('First name: ${widget.contact.name.first}'),
    //   Text('user Id: ${Get.arguments['senderUserId']}'),
    //   Text('Last name: ${widget.contact.name.last}'),
    //   Text(
    //       'Phone number: ${widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : '(none)'}'),
    //   Text(
    //       'Email address: ${widget.contact.emails.isNotEmpty ? widget.contact.emails.first.address : '(none)'}'),
    //   ElevatedButton(
    //       onPressed: (() async {
    //         // sending cherp to contact
    //         // await getTargetUserDetails(widget.contact.phones.first.number);

    //         // if (widget.contact.phones.first.number ==
    //         //     Get.arguments['targetUserNumber']) {
    //         String? postId = Uuid().v4();
    //         int totalComments = 0;

    //         await FirebaseFirestore.instance
    //             .collection("your_cherps")
    //             .doc(postId)
    //             .set({
    //           'senderUserId': Get.arguments['senderUserId'],
    //           'createdAt': DateTime.now(),
    //           'senderUserName': Get.arguments['senderUserName'],
    //           'senderUserNumber': Get.arguments['senderUserNumber'],
    //           'senderUserImg': Get.arguments['senderUserImg'],
    //           'postImg': '',
    //           'targetUserName': targetUserName,
    //           'targetUserId': targetUserId,
    //           'targetUserImg': targetUserImg,
    //           'cherpTotalComment': totalComments,
    //           'cherpLikeUserList': [],
    //           'postId': postId,

    //           // 'targetUserNumber': Get.arguments['senderUserImg'],

    //           'cherpLikes': 0,
    //           'cherpDesc': "",
    //           'targetUserNumber': widget.contact.phones.first.number,
    //           // ignore: todo
    //           // TODO IMP
    //           // 'cherpComments': [
    //           //   {
    //           //     'comments': 'test comment',
    //           //     'commentSenderName': Get.arguments['userName'],
    //           //     'commentDate': DateTime.now(),
    //           //   },
    //           // ],
    //         });
    //         log("Successfully added");
    //         //  else {
    //         //   print('user not exist');
    //         // }
    //       }),
    //       child: Text(
    //         "Cherp",
    //         style: TextStyle(fontSize: 23, color: Colors.white),
    //       ))
    // ])
  }
}
