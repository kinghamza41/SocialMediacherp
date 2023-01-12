// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String? message;
  ProgressDialog({Key? key, this.message}) : super(key: key);

  get appMainColor => null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 6.0,
            ),
            Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.black, Colors.blue])),
              child: CupertinoActivityIndicator(
                radius: 20.0,
                // color: ,
                animating: true,
              ),
            ),
            // const CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            // ),
            const SizedBox(
              width: 26.0,
            ),
            Text(
              message!,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
