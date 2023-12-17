import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../constants/app_theme.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

import '../../middleware/auth_middleware.dart';
import '../controllers/authentication_controller.dart';
import '../models/device_model.dart';
import '../models/role_model.dart';

enum Options { Edit, Delete }

class UserCard extends StatelessWidget {
  User user;
  final int index;
  DatabaseService databaseService = DatabaseService();
  UserController userController;
  List<Device>? devices;

  Role? role;

  UserCard(
      {Key? key,
      required this.user,
      required this.index,
      required this.userController,
      this.devices,
      Role? xxx})
      : super(key: key) {
    role = xxx ?? Role(id: "", name: "", description: "");
  }

  Future<void> _onDeleteData(BuildContext context, User user) async {
    if (AuthorizationMiddleware.checkPermission(
        Get.find<AuthenticationController>(),
        Get.find<UserController>(),
        "/user/delete")) {
      userController.deleteUser(user);
      return print("Check Delete route permission valid");
    }
    {
      Get.snackbar("Delete product", "You don't have permission",
          icon: const Icon(Icons.warning_amber),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      print(
        "Check Delete route permission not valid",
      );
    }

    //   Navigator.of(context).pop();
  }

  Future<void> _onEdit(User user) async {
    userController.user.value = user;
    userController.addEmailController.text = user.email;
    userController.addNameController.text = user.name;

    if (role != null) {
      userController.roleSelected.update((val) {
        val = role!.id;
      });
      userController.role.update((val) {
        val!.name = role!.name;
        val.id = role!.id;
        val.description = role!.description;
      });

      // print(userController.roleSelected.value + "  --  " + role!.name);
    } else {
      userController.roleSelected.update((val) {
        val = "";
      });
    }

    // userController.roleSelected.value = user.roles!.;

    /*   userController.roles.forEach((rl) {
      if (rl.id!.toString().toLowerCase().trim() ==
          value.toString().toLowerCase().trim()) {
        userController.roleSelected.value = rl.id!;
        userController.role.update((val) {
          val!.name = rl.name;
          val.id = rl.id;
          val.description = rl.description;
        });
      }
    });
 */
    userController.imageLink.value = user.photoURL!;

    userController.toUpdateUserView(user);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Device>?> futureListDevice =
        userController.getDeviceByUser(user);
    Future<List<Role>?> futureListRole = userController.getRoleByUser(user);

    return Card(
      shadowColor: Colors.blueGrey,
      elevation: 3,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 189, 207, 216),
                        offset: Offset(0, 1))
                  ],
                  color: Color.fromARGB(255, 232, 234, 239),
                  /* border: Border.all(
                    width: 10,
                    color:  Color.fromARGB(255, 232, 234, 239),
                  ), */
                  borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(4),
                      right: const Radius.circular(4))),
              // color: Color.fromARGB(255, 232, 234, 239),
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Get.find<AuthenticationController>().user != null
                      ? (superUserEmail.toLowerCase() ==
                                  user.email.toLowerCase() &&
                              Get.find<AuthenticationController>()
                                  .authenticated)
                          ? Container()
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: PopupMenuButton(
                                icon: const Icon(Icons.more_vert_rounded),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))),
                                offset: const Offset(0.0, 1),
                                itemBuilder: (ctx) => [
                                  _buildPopMenuItem(
                                      "Edit", Icons.edit, Options.Edit.index),
                                  _buildPopMenuItem("Delete", Icons.remove,
                                      Options.Delete.index),
                                ],
                                onSelected: (value) async {
                                  int selectedValue = value as int;

                                  switch (selectedValue) {
                                    case 0:
                                      /*  Navigator.pushNamed(context, AppPages.EDIT_USER,
                                arguments: user); */
                                      _onEdit(user);
                                      break;
                                    case 1:
                                      if (await confirm(context)) {
                                        _onDeleteData(context, user);

                                        return print('pressedOK');
                                      }

                                      return print('pressedCancel');

                                    default:
                                  }
                                },
                              ),
                            )
                      : Container()
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    user.photoURL == ""
                        ? SizedBox(
                            width: 100,
                            height: 100,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Image.network(user.photoURL!,
                            width: 100, height: 100, fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          })
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* Row(
                      children: [
                        const Text("Role: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.roles!.values.toList()[0],
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ), */
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Email: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.email,
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Created: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(DateTime.parse(user.createdAt)),
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: const [
                              SizedBox(
                                width: 60,
                                child: Text("Roles: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 150,
                                child: FutureBuilder(
                                    future: futureListRole,
                                    builder: (context, snap) {
                                      if (snap.hasError) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snap.connectionState ==
                                          ConnectionState.done) {
                                        List<Role>? roles =
                                            snap.data as List<Role>;

                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: roles.length,
                                            itemBuilder: (context, index) {
                                              role = roles[index];

                                              return Text(roles[index].name);
                                            });
                                      }

                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: const [
                              SizedBox(
                                width: 60,
                                child: Text("Devices: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 30,
                                child: FutureBuilder(
                                    future: futureListDevice,
                                    builder: (context, snap) {
                                      if (snap.hasError) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snap.connectionState ==
                                          ConnectionState.done) {
                                        List<Device>? devices =
                                            snap.data as List<Device>;

                                        print(devices);
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: devices.length,
                                            itemBuilder: (context, index) {
                                              return Text(devices[index]
                                                  .deviceInfo!["device"]);
                                            });
                                      }

                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [],
                    ),
                    Row(
                      children: const [],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  PopupMenuItem _buildPopMenuItem(String s, IconData edit, int index) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(s),
        ],
      ),
      value: index,
    );
  }

  @override
  List<Object?> get props =>
      [user, index, databaseService, userController, devices];
}
