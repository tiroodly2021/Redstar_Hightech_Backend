import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';

import 'menu_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  String title;
  var bgColor;
  String? tooltip;
  IconData? icon;
  Function()? onPressed;
  Function()? onPressedLoginState;
  Function()? onPressedMenu;
  AuthenticationController? authenticationController;
  dynamic menuActionButton = Container(
    child: Text('Hll'),
  );

  AppBarWidget(
      {Key? key,
      required this.title,
      this.bgColor,
      this.tooltip,
      this.icon,
      this.onPressed,
      this.onPressedLoginState,
      this.authenticationController,
      this.menuActionButton,
      this.onPressedMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      /*   leading: IconButton(
          tooltip: 'Menu',
          onPressed: onPressedMenu,
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          )), */
      actions: [
        IconButton(
            color: Colors.white,
            onPressed: () {
              Get.toNamed(AppPages.HOME);
            },
            // tooltip: tooltip,
            icon: const Icon(Icons.home, color: Colors.white)),
        IconButton(
            color: Colors.white,
            onPressed: onPressed,
            // tooltip: tooltip,
            icon: Icon(icon, color: Colors.white)),
        menuActionButton
      ],

      title: Text(title),
      // centerTitle: true,
      backgroundColor: bgColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); //const Size(5, 60);

}
