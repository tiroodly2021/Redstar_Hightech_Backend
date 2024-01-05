import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util.dart';
import '../../constants/app_theme.dart';
import '../../databases/boxes.dart';
import '../../routes/app_pages.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../authentication/controllers/authentication_controller.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
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
              tileColor: Get.currentRoute == Routes.HOME ||
                      Get.currentRoute == Routes.INITIAL
                  ? AppTheme.darkGrayMenu
                  : null,
              textIconColor:
                  Get.currentRoute == Routes.HOME ? Colors.white : Colors.black,
            ),
            buildDrawerItem(
              icon: Icons.person,
              text: "User",
              onTap: () => navigate(1),
              tileColor: Get.currentRoute == Routes.USER
                  ? AppTheme.darkGrayMenu
                  : null,
              textIconColor:
                  Get.currentRoute == Routes.USER ? Colors.white : Colors.black,
            ),
            buildDrawerItem(
                icon: Icons.production_quantity_limits,
                text: "Products",
                onTap: () => navigate(2),
                tileColor: Get.currentRoute == Routes.PRODUCT
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.PRODUCT
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.category,
                text: "Categories",
                onTap: () => navigate(3),
                tileColor: Get.currentRoute == Routes.CATEGORY
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.CATEGORY
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.bar_chart,
                text: "Orders",
                onTap: () => navigate(4),
                tileColor: Get.currentRoute == Routes.ORDER
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.ORDER
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.pending,
                text: "Pending Orders",
                onTap: () => navigate(5),
                tileColor: Get.currentRoute == Routes.PENDING_ORDER
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.PENDING_ORDER
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.cancel,
                text: "Cancelled Orders",
                onTap: () => navigate(6),
                tileColor: Get.currentRoute == Routes.CANCELLED_ORDER
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.CANCELLED_ORDER
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.price_change,
                text: "Finance",
                onTap: () => navigate(7),
                tileColor: Get.currentRoute == Routes.FINANCE_HOME
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.FINANCE_HOME
                    ? Colors.white
                    : Colors.black),
            buildDrawerItem(
                icon: Icons.settings,
                text: "Settings",
                onTap: () => navigate(8),
                tileColor: Get.currentRoute == Routes.SETTINGS
                    ? AppTheme.darkGrayMenu
                    : null,
                textIconColor: Get.currentRoute == Routes.SETTINGS
                    ? Colors.white
                    : Colors.black),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return ValueListenableBuilder(
        valueListenable: Boxes.getStorageBox().listenable(),
        builder: (context, Box box, _) {
          final String imageString = box.get('profilePhoto', defaultValue: '');
          final String userName = box.get('userName', defaultValue: '');
          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                  // topLeft: Radius.circular(10),
                  //topRight: Radius.circular(10),
                  //  bottomLeft: Radius.circular(10),
                  /*  bottomRight: Radius.circular(10) */),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            accountName: Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppTheme.hintLoginColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
            ),
            accountEmail: Get.find<AuthenticationController>().email != null
                ? Text(Get.find<AuthenticationController>().email!)
                : const Text('Guest'),
            currentAccountPicture:
                Get.find<AuthenticationController>().imageurl != null
                    ? Image.network(
                        Get.find<AuthenticationController>().imageurl!,
                        width: 30,
                        height: 30,
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(
                            Get.find<AuthenticationController>().user != null
                                ? 'assets/images/person_connected.png'
                                : 'assets/images/person_disconnected.png'),
                      ),
            currentAccountPictureSize: const Size.square(72),
            otherAccountsPictures: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  Get.find<AuthenticationController>().user != null
                      ? Get.find<AuthenticationController>()
                          .user!
                          .email!
                          .substring(0, 2)
                          .toUpperCase()
                      : 'GS',
                  style: const TextStyle(
                      color: AppTheme.blackTextStyleColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
            otherAccountsPicturesSize: const Size.square(50),
          );
        });
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
        return Get.toNamed(AppPages.FINANCE_HOME);
      case 8:
        return Get.toNamed(AppPages.SETTINGS);

      default:
        return Get.toNamed(AppPages.PRODUCT);
    }
  }
}
