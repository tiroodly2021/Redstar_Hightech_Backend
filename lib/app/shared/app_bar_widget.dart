import 'package:flutter/material.dart';

import 'menu_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  String title;
  var bgColor;
  String? tooltip;
  IconData? icon;
  Function()? onPressed;
  Function()? onPressedLoginState;
  String? userName;

  AppBarWidget(
      {Key? key,
      required this.title,
      this.bgColor,
      this.tooltip,
      this.icon,
      this.onPressed,
      this.onPressedLoginState,
      this.userName})
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
            child: Text(userName ?? 'Guest'),
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
