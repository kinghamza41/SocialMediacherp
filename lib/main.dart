// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, unused_import, await_only_futures, prefer_const_constructors_in_immutables, avoid_print, constant_identifier_names

import 'dart:async';

import 'package:cherp_app/Initial/splash_screen.dart';
import 'package:cherp_app/contacts.dart';
import 'package:cherp_app/firebase_options.dart';
import 'package:cherp_app/sources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'Page/01_home.dart';
import 'Page/02_search.dart';
import 'Page/03_home_info.dart';
import 'Page/04_notification.dart';
import 'Page/05_settings.dart';
import 'Initial/Signin.dart';
import 'Initial/verification.dart';
import 'Page/send_cherp_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // Timer(
    //   Duration(seconds: 2),
    //   (() {
    //     auth();
    //   }),
    // );
    // auth();
    // print(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Twittery",
      // user != null ? TheMain() : Sign_in()
      home: SplashScreen(),
      //initialRoute: 'signin',
      // routes: {
      //   "signin": (context) => Sign_in(),
      //   "verification": (context) => OTP_verification(),
      // "home": (context) => TheMain(),

      // },
    );
  }
}

class TheMain extends StatefulWidget {
  TheMain({this.start_from = 0, super.key});

  int start_from;
  static final my_controller = CarouselController();
  static const icon_names = [
    "globe",
    "search",
    "tweet",
    "ring",
    "account",
  ];

  @override
  State<TheMain> createState() => _TheMainState();
}

class _TheMainState extends State<TheMain> {
  int selected = 0;
  static bool profile = false;
  late Contact contact;

  @override
  Widget build(BuildContext context) {
    Widget bottomLogo(String name, int index) => Expanded(
          child: IconButton(
            onPressed: () => TheMain.my_controller.animateToPage(index),
            icon: SvgPicture.asset(
              "assets/Icon/$name.svg",
              color: index == 2
                  ? null
                  : index == selected
                      ? (sources.is_dark ? Colors.yellow : sources.color_dark)
                      : sources.color_TheOther.withOpacity(0.5),
              // color: index == 2
              //     ? null
              //     : index == selected
              //         ? (sources.is_dark ?
              // color: Colors.yellow,
              //  : sources.color_dark)
              // : sources.color_TheOther.withOpacity(0.5),
              //height: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            sources.is_dark
                ? profile
                    ? sources.background_profile_dark
                    : sources.background_dark
                : profile
                    ? sources.background_profile_light
                    : sources.background_light,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          color: sources.color_selected,
          height: MediaQuery.of(context).size.height * 0.075,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(TheMain.icon_names.length,
                (index) => bottomLogo(TheMain.icon_names[index], index)),
          ),
        ),
        body: CarouselSlider(
          carouselController: TheMain.my_controller,
          options: CarouselOptions(
            initialPage: widget.start_from,
            height: MediaQuery.of(context).size.height * 0.925,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) => setState(() => selected = index),
            scrollPhysics: const NeverScrollableScrollPhysics(),
          ),
          items: [
            MyHomePage(),
            MySearch(),
            MakeCherp(),
            MyNotification(),
            MySettings() //ViaEditButton(),
            //BuyEggs(),
          ],
        ),
      ),
    );
  }
}

    //  MyHomePage(),
    //       MySearch(),
    //       MyHomeInfo(),
    //       MyNotification(),
    //       MySettings(),