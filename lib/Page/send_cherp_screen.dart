// ignore_for_file: non_constant_identifier_names, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:cherp_app/contacts.dart';
import 'package:cherp_app/widget/flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'src/sources.dart';
import '../sources.dart';

class MakeCherp extends StatefulWidget {
  MakeCherp({Key? key}) : super(key: key);

  @override
  State<MakeCherp> createState() => _MakeCherpState();
}

class _MakeCherpState extends State<MakeCherp> {
  // String number=widget.contact.phones.first.number;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // print(Get.arguments['fullContact'] == null
    //     ? 'not found'
    //     : Get.arguments['fullContact']);
    if (Get.arguments != null) {
      print(Get.arguments['fullContact']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent_color = sources.is_dark ? Colors.yellow : Colors.black;

    Widget bottomLogo(String path) => Expanded(
          child: SvgPicture.asset(
            path,
            height: MediaQuery.of(context).size.height * 0.025,
            color: accent_color,
          ),
        );

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ), // 3% Empty screen height
          Container(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                DisplayFlutterToast('Please select contact', context);
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
          const Spacer(), // Spacer
          Row(
            children: [
              bottomLogo(sources.icon_phone),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => Get.to(() => FlutterContactsExample()),
                  child: Text(
                    // widget.contact.phones.first.number?

                    // Get.arguments['fullContact']?
                    'Select Contact',
                    // : Get.arguments['fullContact'],
                    textAlign: TextAlign.left,
                    style: sources.font_style(
                      color: sources.color_TheOther.withOpacity(0.5),
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
              ),
              bottomLogo(sources.icon_photo),
              bottomLogo(sources.icon_video),
              bottomLogo(sources.icon_audio),
            ],
          ), // Select Contact, Photo, Video, Audio
        ],
      ),
    );
  }
}
