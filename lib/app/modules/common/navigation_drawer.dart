import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            buildDrawerHeader(),
            const Divider(
              color: Colors.grey,
            ),
            buildDrawerItem(
              icon: Icons.home,
              text: "Home",
              onTap: () => navigate(0),
              tileColor: Get.currentRoute == Routes.HOME ? Colors.blue : null,
              textIconColor:
                  Get.currentRoute == Routes.HOME ? Colors.white : Colors.black,
            ),
            buildDrawerItem(
              icon: Icons.person,
              text: "User",
              onTap: () => navigate(1),
              tileColor: Get.currentRoute == Routes.USER ? Colors.blue : null,
              textIconColor:
                  Get.currentRoute == Routes.USER ? Colors.white : Colors.black,
            ),
            buildDrawerItem(
                icon: Icons.production_quantity_limits,
                text: "Products",
                onTap: () => navigate(2),
                tileColor:
                    Get.currentRoute == Routes.PRODUCT ? Colors.blue : null,
                textIconColor: Get.currentRoute == Routes.PRODUCT
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.category,
                text: "Categories",
                onTap: () => navigate(3),
                tileColor:
                    Get.currentRoute == Routes.CATEGORY ? Colors.blue : null,
                textIconColor: Get.currentRoute == Routes.CATEGORY
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.bar_chart,
                text: "Orders",
                onTap: () => navigate(4),
                tileColor:
                    Get.currentRoute == Routes.ORDER ? Colors.blue : null,
                textIconColor: Get.currentRoute == Routes.ORDER
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.pending,
                text: "Pending Orders",
                onTap: () => navigate(5),
                tileColor: Get.currentRoute == Routes.PENDING_ORDER
                    ? Colors.blue
                    : null,
                textIconColor: Get.currentRoute == Routes.PENDING_ORDER
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.cancel,
                text: "Cancelled Orders",
                onTap: () => navigate(6),
                tileColor: Get.currentRoute == Routes.CANCELLED_ORDER
                    ? Colors.blue
                    : null,
                textIconColor: Get.currentRoute == Routes.CANCELLED_ORDER
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.settings,
                text: "Settings",
                onTap: () => navigate(7),
                tileColor:
                    Get.currentRoute == Routes.SETTINGS ? Colors.blue : null,
                textIconColor: Get.currentRoute == Routes.SETTINGS
                    ? Colors.white
                    : Colors.black),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      accountName: Text("Ripples Code"),
      accountEmail: Text("ripplescode@gmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/appicon.png'),
      ),
      currentAccountPictureSize: Size.square(72),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Text("RC"),
        )
      ],
      otherAccountsPicturesSize: Size.square(50),
    );
  }

  Widget buildDrawerItem({
    required String text,
    required IconData icon,
    required Color textIconColor,
    required Color? tileColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textIconColor),
      title: Text(
        text,
        style: TextStyle(color: textIconColor),
      ),
      tileColor: tileColor,
      onTap: onTap,
    );
  }

  navigate(int index) {
    /* if (index == 0) {
      Get.toNamed(Routes.HOME);
    } else if (index == 1) {
      Get.toNamed(Routes.USER);
    }
    if (index == 2) {
      Get.toNamed(Routes.PRODUCT);
    } */

    switch (index) {
      case 0:
        return Get.toNamed(AppPages.HOME);
      case 1:
        return Get.toNamed(AppPages.USER);
      case 2:
        return Get.toNamed(AppPages.PRODUCT);
      case 3:
        return Get.toNamed(AppPages.CATEGORY);
      case 4:
        return Get.toNamed(AppPages.ORDER);
      case 5:
        return Get.toNamed(AppPages.PENDING_ORDER);
      case 6:
        return Get.toNamed(AppPages.CANCELLED_ORDER);
      case 7:
        return Get.toNamed(AppPages.SETTINGS);

      default:
        return Get.toNamed(AppPages.PRODUCT);
    }
  }
}
