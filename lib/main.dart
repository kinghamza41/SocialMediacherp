// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable

import 'package:cherp_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'Page/01_home.dart';
import 'Page/02_search.dart';
import 'Page/03_home_info.dart';
import 'Page/04_notification.dart';
import 'Page/05_settings.dart';
import 'Initial/Signin.dart';
import 'Initial/verification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Twittery",
      initialRoute: (user != null ? "home" : "signin"),
      routes: {
        "signin": (context) => Sign_in(),
        "verification": (context) => OTP_verification(),
        "home": (context) => TheMain(),
      },
    );
  }
}

class TheMain extends StatefulWidget {
  const TheMain({Key? key}) : super(key: key);

  static final my_controller = CarouselController();

  @override
  State<TheMain> createState() => _TheMainState();
}

class _TheMainState extends State<TheMain> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    Widget bottomLogo(String name, {int index = 5}) => Expanded(
          child: IconButton(
            onPressed: () => TheMain.my_controller.animateToPage(index),
            icon: SvgPicture.asset(
              "assets/Icon/$name.svg",
              color: index == 5
                  ? Colors.white.withOpacity(0.1)
                  : // Remove it later
                  index == selected
                      ? Colors.yellow
                      : Colors.white.withOpacity(0.5),
              height: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        );

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height * 0.075,
        child: Row(
          children: [
            bottomLogo("globe", index: 0),
            bottomLogo("search", index: 1),
            bottomLogo("main_transparent", index: 2),
            bottomLogo("ring", index: 3),
            bottomLogo("account", index: 4),
          ],
        ),
      ),
      body: CarouselSlider(
        carouselController: TheMain.my_controller,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.925,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) => setState(() => selected = index),
          scrollPhysics: const NeverScrollableScrollPhysics(),
        ),
        items: const [
          MyHomePage(),
          MySearch(),
          MyHomeInfo(),
          MyNotification(),
          MySettings(),
        ],
      ),
    );
  }
}
