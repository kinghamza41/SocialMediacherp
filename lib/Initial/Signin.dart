// // ignore_for_file: unused_import, camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, camel_case_types, unused_local_variable, non_constant_identifier_names, unused_import, file_names, avoid_print, prefer_interpolation_to_compose_strings, unused_field

import 'package:cherp_app/Initial/verification.dart';
import 'package:cherp_app/widget/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Sign_in extends StatefulWidget {
  const Sign_in({super.key});
  static String verify = "";

  @override
  State<Sign_in> createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
  dynamic phone;
  dynamic countryCode;
  String authStatus = "";
  // String verificationId;
  String otp = "";
  String id = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;
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
              child: Text("Enter Your Phone Number",
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
                "We will send you one time password on this number",
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
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: IntlPhoneField(
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                initialCountryCode: 'PK',
                onChanged: (value) {
                  // phone=value;
                  print(value.completeNumber);
                  phone = value.completeNumber;
                },
                onCountryChanged: (value) {
                  countryCode = value.dialCode;
                  print('Country changed to: ' + value.dialCode);
                },
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  prefixIconColor: Colors.white,
                ),
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
                    //  print(phone.toString());
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return ProgressDialog(
                            message: "Please Wait..",
                          );
                        });
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phone,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        setState(() {
                          id = verificationId;
                          print("Verf id $id");
                        });
                        Navigator.pop(context);

                        Get.off(() => OTP_verification(), arguments: {
                          "id": id,
                          'phoneNumber': phone,
                        });
                      },
                      codeAutoRetrievalTimeout: (String verId) {
                        // Sign_in.verify = verId;
                        // setState(() {
                        //   authStatus = "TIMEOUT";
                        // });
                      },
                    );
                  },
                  child: Text(
                    "Send OTP",
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
