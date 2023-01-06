// ignore_for_file: file_names

import 'package:cherp_app/Page/src/sources.dart';
import 'package:flutter/material.dart';
import '../sources.dart';

class MyHomeInfo extends StatelessWidget {
  const MyHomeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget levelText(String text) => Text(
      text,
      style: sources.font_style(
        //fontSize: 15,
        fontSize: MediaQuery.of(context).size.height * 0.02,
        //fontSize: MediaQuery.of(context).size.width * 0.04,
        color: const Color(0xFF424300),
      ),
    );
    Widget cherpsOne(String text, bool enabled) => Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Text(
              text,
              style: sources.font_style(
                //fontSize: 15,
                fontSize: MediaQuery.of(context).size.height * 0.02,
                //fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.white.withOpacity(enabled ? 0.8 : 0.4),
                fontWeight: enabled ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Divider(
            color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
            thickness: 2,
          ),
        ],
      ),
    );

    return DarkOne(
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                ),    // 4% of the screen height
                 const Flexible(
                  flex: 2,
                  child: MyAvatar(aspect: 0.1),
                ),
                Text(
                  settings_info.name,
                  style: sources.font_style(
                    //fontSize: 20,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.white,
                  ),
                ),        // Name
                Text(
                  settings_info.username,
                  style: sources.font_style(
                    //fontSize: 15,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),        // Username
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFfffcdd),
                      border: Border.all(
                        color: Colors.yellow.withOpacity(0.7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.005,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        levelText("Level 2"),
                        levelText("9,777"),
                      ],
                    ),
                  ),
                ),    // Level
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    settings_info.biography,
                    textAlign: TextAlign.center,
                    style: sources.font_style(
                      //fontSize: 15,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      //fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),     // Biography
                Flexible(
                  child: Row(
                    children: [
                      cherpsOne("Your Cherps", true),
                      cherpsOne("Received Cherps", false),
                    ],
                  ),
                ),    // Cherps
              ],
            ),
          ),         // Profile
          const Expanded(
            flex: 5,
            child: Tweets(),
          ),   // Home
        ],
      ),
    );
  }
}
