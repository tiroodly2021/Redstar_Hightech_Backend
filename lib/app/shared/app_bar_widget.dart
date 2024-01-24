import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/style/colors.dart';

import 'menu_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {Key? key,
      required this.title,
      this.leading,
      this.bgColor,
      this.tooltip,
      this.icon,
      this.onPressed,
      this.onPressedLoginState,
      this.authenticationController,
      this.menuActionButton,
      this.onPressedMenu})
      : super(key: key);

  AuthenticationController? authenticationController;
  var bgColor;
  IconData? icon;
  Widget? leading;
  dynamic menuActionButton = Container();
  String title;
  String? tooltip;

  @override
  Size get preferredSize => const Size.fromHeight(60); //const Size(5, 60);

  Function()? onPressed;

  Function()? onPressedLoginState;

  Function()? onPressedMenu;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: [
        IconButton(
            color: Colors.white,
            onPressed: () {
              authenticationController?.checkUserRolePermission().then((role) {
                role.name == FINANCE_ROLE
                    ? Get.toNamed(AppPages.FINANCE_HOME)
                    : Get.toNamed(AppPages.HOME);
              });
            },
            // tooltip: tooltip,
            icon: const Icon(Icons.home, color: Colors.white)),
        IconButton(
            color: Colors.white,
            onPressed: onPressed,
            // tooltip: tooltip,
            icon: Icon(icon, color: Colors.white)),
        menuActionButton,
      ],

      title: Text(title),
      // centerTitle: true,
      backgroundColor: bgColor,
    );
  }
}
