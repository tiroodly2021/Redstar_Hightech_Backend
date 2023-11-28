import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';

import 'menu_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  String title;
  var bgColor;
  String? tooltip;
  IconData? icon;
  Function()? onPressed;
  Function()? onPressedLoginState;
  AuthenticationController? authenticationController;

  AppBarWidget(
      {Key? key,
      required this.title,
      this.bgColor,
      this.tooltip,
      this.icon,
      this.onPressed,
      this.onPressedLoginState,
      this.authenticationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const MenuWidget(),
      actions: [
        IconButton(
            color: Colors.white,
            onPressed: onPressed,
            // tooltip: tooltip,
            icon: Icon(icon, color: Colors.white)),
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.transparent),
            child: (authenticationController!.user != null)
                ? (authenticationController!.imageurl != null
                    ? Image.network(
                        authenticationController!.imageurl!,
                        width: 40,
                        height: 50,
                      )
                    : Container(
                        width: 40,
                        height: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/person_connected.png"),
                            fit: BoxFit.cover,
                          ),
                        )))
                : Container(
                    width: 40,
                    height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/person_disconnected.png"),
                        fit: BoxFit.cover,
                      ),
                    ))

            /* 
            
                 ? (authenticationController.imageurl != null
                ? Image.network(authenticationController.imageurl!)
                : const AssetImage("assets/images/person_default.jpg"))
            : const AssetImage("assets/images/person_default.jpg")

            Container(
                decoration: BoxDecoration(
              image: DecorationImage(
                image: userAvatar,
                fit: BoxFit.cover,
              ),
            )) */
            ,
            onPressed: onPressedLoginState)
      ],

      title: Text(title),
      // centerTitle: true,
      backgroundColor: bgColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); //const Size(5, 60);

}
