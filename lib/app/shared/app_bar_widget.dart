import 'package:flutter/material.dart';

import 'menu_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  String title;
  var bgColor;
  String? tooltip;
  IconData? icon;
  Function()? onPressed;

  AppBarWidget(
      {Key? key,
      required this.title,
      this.bgColor,
      this.tooltip,
      icon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const MenuWidget(),
      actions: [
        IconButton(
            color: Colors.white,
            onPressed: onPressed,
            tooltip: tooltip,
            icon: Icon(icon, color: Colors.white))
      ],

      title: Text(title),
      // centerTitle: true,
      backgroundColor: bgColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); //const Size(5, 60);
}
