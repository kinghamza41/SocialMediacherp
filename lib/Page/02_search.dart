// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'src/sources.dart';
import '../sources.dart';

class MySearch extends StatelessWidget {
  const MySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DarkOne(
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: text_field(context, "Search"),
        ),
        const Expanded(
            child: Tweets()
        ),
      ],
    ),
  );
}