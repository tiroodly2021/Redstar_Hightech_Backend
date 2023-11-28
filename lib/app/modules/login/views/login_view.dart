import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
//import 'package:velocity_x/velocity_x.dart';

import '../controllers/login_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginView extends GetView<LoginController> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/backgroundUI.png"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        width: 100,
                        child: SvgPicture.asset("assets/images/xing.svg")),
                    const SizedBox(
                      height: 10,
                    ),
                    //    const HeightBox(10),
                    // "Login".text.color(Colors.white).size(20).make(),
                    // const HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          isDense: true, // Added this
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextField(
                        controller: pass,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          isDense: true, // Added this
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Register Now',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0XFF4321F5)),
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






/* class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LoginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
 */