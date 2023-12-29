import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Menu',
        onPressed: () {
          //DrawerScaffold.currentController(context)
          DrawerScaffold.currentController(context).toggle();
        },
        icon: const Icon(Icons.menu));
  }
}
