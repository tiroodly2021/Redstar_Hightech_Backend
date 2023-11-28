import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
//import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_theme.dart';
import '../controllers/login_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/home_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/home_view.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_theme.dart';

//import 'package:google_fonts/google_fonts.dart';

/*class LoginView extends GetView<LoginController> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  final colorizeColors = [
    Colors.black,
    Colors.black,
    Colors.blue,
    AppTheme.appbarColor,
    Colors.transparent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade100,
          ),
          Image.asset('assets/images/spl_top.png'),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset('assets/images/spl_bottom.png'),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            /*  Navigator.pushReplacementNamed(
                                    context, AppPages.HOME); */
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(2, 5),
                                          blurRadius: 10.0,
                                          color: Color.fromARGB(100, 0, 0, 0),
                                        )
                                      ]),
                                  clipBehavior: Clip.antiAlias,
                                  child:
                                      Image.asset('assets/images/appicon.png'),
                                ),
                                const SizedBox(height: 20),
                                AnimatedTextKit(
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                        'Redstar Hightech & More',
                                        textStyle: const TextStyle(
                                            color: Colors.amberAccent,
                                            fontSize: 16),
                                        /*  textStyle: GoogleFonts.righteous(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const Shadow(
                                offset: Offset(2, 5),
                                blurRadius: 10.0,
                                color: Color.fromARGB(100, 0, 0, 0),
                              ),
                            ]), */
                                        speed:
                                            const Duration(milliseconds: 600),
                                        colors: colorizeColors),
                                  ],
                                  isRepeatingAnimation: false,
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: TextField(
                                    controller: email,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Colors.blue)),
                                      isDense: true, // Added this
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 10),
                                    ),
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                // const HeightBox(20),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: TextField(
                                    controller: pass,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Colors.blue)),
                                      isDense: true, // Added this
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 10),
                                    ),
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // const HeightBox(20),
                                GestureDetector(
                                  onTap: () {
                                    // Get.to(ForgotPassword());
                                  },
                                  child: const Text(
                                    "Forgot Password ? Reset Now",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // const HeightBox(10),
                                GestureDetector(
                                    onTap: () {
                                      print("Login Clicked Event");
                                      _login();
                                    },
                                    child: const Text(
                                        "Login") /* "Login"
                                .text
                                .white
                                .light
                                .xl
                                .makeCentered()
                                .box
                                .white
                                .shadowOutline(outlineColor: Colors.grey)
                                .color(const Color(0XFFFF0772))
                                .roundedLg
                                .make()
                                .w(150)
                                .h(40)),
                                              const HeightBox(20),
                                              "Login with".text.white.makeCentered(), */
                                    // SocialSignWidgetRow()
                                    )
                              ],
                            ))
                      ],
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }

  void _login() {
    // var loginController = Get.find<LoginController>();
    loginController.login(email.text, pass.text);
  }
}*/

class LoginView extends GetView<LoginController> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  final colorizeColors = [
    Colors.black,
    Colors.black,
    Colors.blue,
    AppTheme.appbarColor,
    Colors.transparent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              /*   Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.shade100,
              ),
              Image.asset('assets/images/spl_top.png'),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset('assets/images/spl_bottom.png'),
              ) */
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/backgroundUI.png"),
                        fit: BoxFit.cover)),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            color: AppTheme.iconButtonColor,
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              /*  Navigator.pushReplacementNamed(
                                  context, AppPages.HOME); */
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 100),
                              child: Column(
                                children: [
                                  Container(
                                      height: 100,
                                      width: 100,
                                      child: SvgPicture.asset(
                                          "assets/images/xing.svg")),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //    const HeightBox(10),
                                  // "Login".text.color(Colors.white).size(20).make(),
                                  // const HeightBox(20),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextField(
                                      controller: email,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: const TextStyle(
                                            color: AppTheme.hintLoginColor),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: AppTheme
                                                  .inputBorderSideColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: AppTheme
                                                    .focusBorderSideColor)),
                                        isDense: true, // Added this
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 20, 10, 10),
                                      ),
                                      cursorColor: AppTheme.cursoStyleColor,
                                      style: const TextStyle(
                                          color: AppTheme.textFieldStyleColor),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // const HeightBox(20),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextField(
                                      controller: pass,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: const TextStyle(
                                            color: AppTheme.hintLoginColor),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: AppTheme
                                                  .inputBorderSideColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                color: AppTheme
                                                    .focusBorderSideColor)),
                                        isDense: true, // Added this
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 20, 10, 10),
                                      ),
                                      cursorColor: AppTheme.cursoStyleColor,
                                      style: const TextStyle(
                                          color: AppTheme.textFieldStyleColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // const HeightBox(20),
                                  GestureDetector(
                                    onTap: () {
                                      // Get.to(ForgotPassword());
                                    },
                                    child: const Text(
                                      "Forgot Password ? Reset Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // const HeightBox(10),
                                  GestureDetector(
                                      onTap: () {
                                        print("Login Clicked Event");
                                        _login();
                                      },
                                      child: const Text(
                                          "Login") /* "Login"
                                .text
                                .white
                                .light
                                .xl
                                .makeCentered()
                                .box
                                .white
                                .shadowOutline(outlineColor: Colors.grey)
                                .color(const Color(0XFFFF0772))
                                .roundedLg
                                .make()
                                .w(150)
                                .h(40)),
                                              const HeightBox(20),
                                              "Login with".text.white.makeCentered(), */
                                      // SocialSignWidgetRow()
                                      )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                  onTap: () {
                    /*  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => RegistrationPage())); */
                  },
                  child: RichText(
                      text: const TextSpan(
                    text: 'New User?',
                    style: TextStyle(
                        fontSize: 15.0, color: AppTheme.richTextStyleColor),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Register Now',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppTheme.textRichSpanStyleColor),
                      ),
                    ],
                  )) //.pLTRB(20, 0, 0, 15),
                  ),
            ),
          ],
        ));
  }

  void _login() {
    // var loginController = Get.find<LoginController>();
    loginController.login(email.text, pass.text);
  }
}
