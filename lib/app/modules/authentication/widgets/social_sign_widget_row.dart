import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';

class SocialSignWidgetRow extends GetWidget<AuthenticationController> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            print("Google Clicked");
            //authenticationController = Get.find<AuthenticationController>();
            authenticationController.google_signIn();
          },
          child: Container(
            width: 30,
            height: 30,
            child: SvgPicture.asset("assets/images/google.svg"),
          ),
        ),
        /* GestureDetector(
          onTap: (){
            print("Facebook Clicked");

            controller.fb_login();
          },
          child: Container(
            width: 30,
            height: 30,
            child: SvgPicture.asset("images/assets/facebook.svg"),
          ),
        ), */
      ],
    );
  }
}
