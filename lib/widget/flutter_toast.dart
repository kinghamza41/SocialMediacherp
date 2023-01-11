// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

DisplayFlutterToast(String message, BuildContext context) {
  Fluttertoast.showToast(
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 1,
    msg: message,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}
