// ignore_for_file: unused_import, camel_case_types, prefer_const_constructors, non_constant_identifier_names, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_element, unused_local_variable, avoid_print, prefer_is_empty

import 'dart:math';

import 'package:cherp_app/Initial/Signin.dart';
import 'package:cherp_app/Page/01_home.dart';
import 'package:cherp_app/Page/05_settings.dart';
import 'package:cherp_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';

class OTP_verification extends StatefulWidget {
  const OTP_verification({super.key});

  @override
  State<OTP_verification> createState() => _OTP_verificationState();
}

class _OTP_verificationState extends State<OTP_verification> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String verfiyId = "";
  dynamic code = "";
  dynamic phone;

  // Future getUser() async {
  //   if (user != null) {
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('users').get();

  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    phone = Get.arguments['phoneNumber'];
    print(phone);
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;

    Widget OTPbox(code) {
      return Container(
        height: screen_height * 0.06,
        width: screen_height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.1)),
        child: TextField(
          onChanged: (value) {
            code = value;
          },
          maxLength: 1,
          keyboardType: TextInputType.number,
          cursorColor: Colors.white,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      );
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: screen_height,
          width: screen_width,
          child: Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
        ),
        ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                    top: screen_height / 5, bottom: screen_height / 10),
                height: screen_height / 8,
                child: Image.asset(
                  "assets/Icon/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text("OTP Verification",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  )),
            ),
            SizedBox(
              height: screen_height / 70,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Enter the OTP sent to your number",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              height: screen_height / 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: 250,
                // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Pinput(
                  // controller: pinController,
                  //  focusNode: focusNode,
                  length: 6,
                  // androidSmsAutofillMethod:
                  //     AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  //  defaultPinTheme: defaultPinTheme,
                  // validator: (value) {
                  //   return value == '2222' ? null : 'Pin is incorrect';
                  // },
                  // onClipboardFound: (value) {
                  //   debugPrint('onClipboardFound: $value');
                  //   pinController.setText(value);
                  // },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('onCompleted: $pin');
                    setState(() {
                      code = pin;
                    });
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                    print(value);
                    // code = value;
                    // setState(() {
                    //   code = value;
                    // });
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  // focusedPinTheme: defaultPinTheme.copyWith(
                  //   decoration: defaultPinTheme.decoration!.copyWith(
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: focusedBorderColor),
                  //   ),
                  // ),
                  // submittedPinTheme: defaultPinTheme.copyWith(
                  //   decoration: defaultPinTheme.decoration!.copyWith(
                  //     color: fillColor,
                  //     borderRadius: BorderRadius.circular(19),
                  //     border: Border.all(color: focusedBorderColor),
                  //   ),
                  // ),
                  // errorPinTheme: defaultPinTheme.copyBorderWith(
                  //   border: Border.all(color: Colors.redAccent),
                  // ),
                ),
              ),
            ),
            SizedBox(
              height: screen_height / 70,
            ),
            GestureDetector(
              onTap: () {},
              child: Center(
                child: Text.rich(TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    children: [
                      TextSpan(
                          text: "Resend",
                          style: TextStyle(
                              color: Color.fromARGB(255, 252, 231, 42),
                              fontSize: 13,
                              fontWeight: FontWeight.bold))
                    ])),
              ),
            ),
            SizedBox(
              height: screen_height * 0.15,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: screen_height / 15,
                width: screen_width / 1.5,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 252, 231, 42),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    // print(Get.arguments["id"]);
                    verfiyId = Get.arguments["id"];
                    try {
                      final AuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: Get.arguments["id"],
                        smsCode: code.toString(),
                      );
                      User? userCredential =
                          (await auth.signInWithCredential(credential)).user;
                      final QuerySnapshot result = await FirebaseFirestore
                          .instance
                          .collection("users")
                          .where('userId', isEqualTo: userCredential?.uid)
                          .get();
                      List<DocumentSnapshot> document = result.docs;
                      if (document.length > 0) {
                        Get.offAll(() => TheMain());
                      } else {
                        await firebaseFirestore
                            .collection("users")
                            .doc(userCredential!.uid)
                            .set({
                          'createdAt': DateTime.now(),
                          'userName': "",
                          'email': "",
                          'phoneNumber': phone,
                          'userImg': "",
                          "userId": userCredential.uid,
                        }).then(
                          (value) => Get.offAll(
                            () => TheMain(),
                          ),
                        );
                      }
                    } catch (e) {
                      e.printError();
                    }
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screen_height * 0.05,
            ),
          ],
        )
      ],
    ));
  }
}
