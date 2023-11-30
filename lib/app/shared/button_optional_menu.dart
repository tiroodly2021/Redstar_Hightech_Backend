import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/authentication/controllers/authentication_controller.dart';
import '../modules/settings/views/edit_profile.dart';
import '../modules/settings/views/settings_view.dart';
import '../routes/app_pages.dart';

class ButtonOptionalMenu extends StatelessWidget {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  ButtonOptionalMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authenticationController = Get.find<AuthenticationController>();
    return authenticationController.user == null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.transparent),
            onPressed: () {
              Navigator.pushNamed(context, AppPages.LOGIN);
            },
            child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/person_disconnected.png"),
                    fit: BoxFit.cover,
                  ),
                )),
          )
        : PopupMenuButton(
            icon: Get.find<AuthenticationController>().imageurl != null
                ? Image.network(
                    Get.find<AuthenticationController>().imageurl!,
                    width: 30,
                    height: 30,
                  )
                : Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/person_connected.png"),
                        fit: BoxFit.cover,
                      ),
                    )),
            itemBuilder: (context) => [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Profile"),
                        ],
                      )),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Settings"),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        Text("Sign Out"),
                      ],
                    ),
                    onTap: () {
                      authenticationController.signout();
                    },
                  ),
                ],
            onSelected: (item) => selectedItem(context, item));
  }

  selectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        print('Profile selected');

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(),
                settings: const RouteSettings(name: AppPages.EDIT_PROFILE)));
        break;
      case 1:
        print('Setting selected');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsView(),
                settings: const RouteSettings(name: AppPages.SETTINGS)));
        break;
      case 2:
        print('Logout selected');
        break;

      default:
        print('default');
    }
  }
}
