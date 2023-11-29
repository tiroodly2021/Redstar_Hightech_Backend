import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../constants/app_theme.dart';
import '../controllers/authentication_controller.dart';
import '../widgets/social_sign_widget_row.dart';

class RegistrationView extends GetView<AuthenticationController> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final TextEditingController firstn = TextEditingController();
  final TextEditingController lastn = TextEditingController();

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              padding: const EdgeInsets.symmetric(vertical: 50),
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

                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextField(
                                      controller: firstn,
                                      decoration: InputDecoration(
                                        hintText: 'First Name',
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
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextField(
                                      controller: lastn,
                                      decoration: InputDecoration(
                                        hintText: 'Last Name',
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
                                    height: 10,
                                  ), //    const HeightBox(10),
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
                                    height: 10,
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
                                    height: 20,
                                  ),
                                  // const HeightBox(10),
                                  GestureDetector(
                                      onTap: () {
                                        if (email.text != "" &&
                                            firstn.text != "" &&
                                            lastn.text != "" &&
                                            pass.text != "") registerUser();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: AppTheme
                                                .buttonTextDecorationColor,
                                            border: Border.all(
                                                color: AppTheme
                                                    .buttonTextDecorationColor),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                  spreadRadius: 10,
                                                  blurRadius: 12)
                                            ]),
                                        child: const Center(
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color:
                                                    AppTheme.richTextStyleColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ) /*  Container(
                                        padding: EdgeInsets.all(10),
                                        color:
                                            AppTheme.buttonLoginBackgroundColor,
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              color:
                                                  AppTheme.richTextStyleColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              decorationStyle:
                                                  TextDecorationStyle.solid),
                                        ),
                                      )  */ /* "Login"
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
                                      ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SocialSignWidgetRow()
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

  void registerUser() {
    authenticationController.createUser(
        firstn.text, lastn.text, email.text, pass.text);
  }
}
