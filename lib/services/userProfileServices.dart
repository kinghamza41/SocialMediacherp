// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, file_names, unused_local_variable

import 'dart:io';

import 'package:cherp_app/widget/progress_dialog.dart';
import 'package:cherp_app/widget/flutter_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

updateUserProfileData(
  BuildContext context,
  File? selectedImage,
  TextEditingController userNameController,
  TextEditingController fullNameController,
  TextEditingController profileBioController,
) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Please Wait..",
        );
      });
  String? imageurl;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseStorage.instance
      .ref()
      .child("UserProfileImages")
      .child(DateTime.now().toString() + ".jpg");

  await ref.putFile(selectedImage!);
  imageurl = await ref.getDownloadURL();

  try {
    users.doc(user?.uid).update({
      'userImg': imageurl,
      'userName': userNameController.text.trim(),
      'userProfileBio': profileBioController.text.trim(),
      'fullName': userNameController.text.trim(),
    }).then((value) {
      Navigator.pop(context);
      DisplayFlutterToast("Data has been updated..", context);
    }).catchError((error) {
      DisplayFlutterToast("Failed to update user: $error", context);
    });
  } catch (e) {
    DisplayFlutterToast("Failed to update user: $e", context);
  }
}

updateOnlyFields(
  BuildContext context,
  TextEditingController userNameController,
  TextEditingController fullNameController,
  TextEditingController profileBioController,
) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Please Wait..",
        );
      });
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseStorage.instance;

  try {
    users.doc(user?.uid).update({
      'userName': userNameController.text.trim(),
      'userProfileBio': profileBioController.text.trim(),
      'fullName': userNameController.text.trim(),
    }).then((value) {
      Navigator.pop(context);
      DisplayFlutterToast("Data has been updated..", context);
    }).catchError((error) {
      DisplayFlutterToast("Failed to update user: $error", context);
    });
  } catch (e) {
    DisplayFlutterToast("Failed to update user: $e", context);
  }
}
