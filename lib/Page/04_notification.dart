// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class MyNotification extends StatelessWidget {
  const MyNotification({Key? key}) : super(key: key);
  static const List<IconData> iconList = [
    Icons.messenger,
    Icons.notifications,
    Icons.call,
    Icons.messenger,
    Icons.favorite,
    Icons.backpack,
    Icons.call,
    Icons.backup,
    Icons.call,
    Icons.favorite,
  ];

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;

    Widget row_sizedbox() {
      return SizedBox(
        width: screen_width * 0.03,
      );
    }

    Widget sizedbox() {
      return SizedBox(
        height: screen_height * 0.03,
      );
    }

    Widget single_notification(int index) {
      return Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage:
                    AssetImage("assets/Placeholder/${index + 1}.png"),
              ),
              const Positioned(
                top: 35,
                left: 38,
                child: Icon(
                  Icons.brightness_1,
                  color: Color.fromARGB(255, 252, 231, 42),
                  size: 27,
                ),
              ),
              Positioned(
                  top: 43,
                  left: 45,
                  child: Icon(
                    iconList[index],
                    color: Colors.white,
                    size: 13,
                  )),
            ],
          ),
          row_sizedbox(),
          Text("You have ${10 - index} new notification",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              )),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: screen_height / 15,
        horizontal: screen_width / 15,
      ),
      children: [
        const Text("Notifications",
            style: TextStyle(
                letterSpacing: 2,
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: screen_height * 0.07,
        ),
        ...List.generate(
            iconList.length,
            (index) => Column(
                  children: [
                    single_notification(index),
                    sizedbox(),
                  ],
                )),
      ],
    );
  }
}
