import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/add_user.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/role_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/widgets/user_widget.dart';

import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/app/shared/list_not_found.sharedWidgets.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../models/device_model.dart';
import '../models/user_model.dart';

class UserView extends GetView<UserController> {
  var exists;

  UserView({Key? key}) : super(key: key);

  Future<void> _pullRefresh() async {
    controller.userList();
  }

  @override
  Widget build(BuildContext context) {
    // controller.userList();

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Users',
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: AppSearchDelegate());
          },
          authenticationController: Get.find<AuthenticationController>(),
          menuActionButton: ButtonOptionalMenu(),
          tooltip: 'Search',
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppPages.ADD_USER);
                  },
                  child: Card(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.toNamed(AppPages.ADD_USER);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        const Text(
                          "Add New User",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: 60,
                child: Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("All Roles",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () {
                                // Get.to(() => RoleView());
                                Get.toNamed(AppPages.ROLE);
                              },
                              icon: const Icon(Icons.list))
                        ]),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.users.isNotEmpty) {
                    return ListView.builder(
                        itemCount: controller.users.length,
                        itemBuilder: ((context, index) {
                          User user = controller.users[index];

                          //   controller.getDeviceByUser(user);

                          if (superUserEmail.toLowerCase() ==
                                  user.email.toLowerCase() &&
                              Get.find<AuthenticationController>()
                                  .authenticated) {
                            if (Get.find<AuthenticationController>().user !=
                                null) {
                              if (Get.find<AuthenticationController>()
                                      .user!
                                      .email!
                                      .toLowerCase() !=
                                  superUserEmail.toLowerCase()) {
                                return Container();
                              }
                            }
                          }

                          if (Get.find<AuthenticationController>().user ==
                                  null &&
                              superUserEmail.toLowerCase() ==
                                  controller.users[index].email.toLowerCase()) {
                            return Container();
                          }

                          return SizedBox(
                            height: 300,
                            child: UserCard(
                                user: user,
                                index: index,
                                userController:
                                    controller /* ,
                              devices: controller.devices.value != <Device>[]
                                  ? controller.devices
                                  : [], */
                                ),
                          );
                        }));
                  }

                  return ListNotFound(
                      route: AppPages.INITIAL,
                      message: "There are not user in the list",
                      info: "Go Back",
                      imageUrl: "assets/images/empty.png");
                }),
              )
            ],
          ),
        ));
  }
}
