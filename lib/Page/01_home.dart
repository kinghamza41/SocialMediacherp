// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'src/sources.dart';
import '../sources.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DarkOne(
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        SvgPicture.asset(
          sources.icon_main,
          height: MediaQuery.of(context).size.height * 0.04,
          color: Colors.yellow,
        ),
        const Expanded(
            child: Tweets()
        ),
      ],
    ),
  );
}