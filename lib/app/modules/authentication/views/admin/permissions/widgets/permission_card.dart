import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../../../middleware/auth_middleware.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../../../controllers/permission_controller.dart';
import '../../../../controllers/permission_controller.dart';
import '../../../../models/permission_model.dart';
import '../../../../models/permission_model.dart';

import 'package:intl/intl.dart';

enum Options { Edit, Delete }

class PermissionCard extends StatelessWidget {
  Permission permission;
  final int index;
  //DatabaseService databaseService = DatabaseService();
  PermissionController permissionController;

  PermissionCard({
    Key? key,
    required this.permission,
    required this.index,
    required this.permissionController,
  }) : super(key: key);

  Future<void> _onDeleteData(
      BuildContext context, Permission permission) async {
    if (AuthorizationMiddleware.checkPermission(
        Get.find<AuthenticationController>(),
        Get.find<UserController>(),
        "/permission/delete")) {
      permissionController.deletePermission(permission);
      return print("Check Delete route permission valid");
      //   Navigator.of(context).pop();
    }
    {
      Get.snackbar("Delete product", "You don't have permission",
          icon: const Icon(Icons.warning_amber),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
    }

    //   Navigator.of(context).pop();
  }

  /* Future<void> _onEdit(Permission permission) async {
    permissionController.permission.value = permission;
    permissionController.addDescriptionController.text = permission.description;
    permissionController.roleSelected.value = permission.role;
    permissionController.checkList['isRead'] = permission.read;
    permissionController.checkList['isWrite'] = permission.write;
    permissionController.checkList['isDelete'] = permission.delete;
    permissionController.toUpdatePermissionView(permission);
  } */

  @override
  Widget build(BuildContext context) {
    //final UserController userController = Get.find();

    return Card(
      shadowColor: Colors.blueGrey,
      elevation: 3,
      margin: const EdgeInsets.only(
        top: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                      left: Radius.circular(4), right: Radius.circular(4))),
              // color: Color.fromARGB(255, 232, 234, 239),
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        permission.description,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
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
                        /*  _buildPopMenuItem(
                            "Edit", Icons.edit, Options.Edit.index), */
                        _buildPopMenuItem(
                            "Delete", Icons.remove, Options.Delete.index),
                      ],
                      onSelected: (value) async {
                        int selectedValue = value as int;

                        switch (selectedValue) {
                          /*  case 0:
                            /*  Navigator.pushNamed(context, AppPages.EDIT_USER,
                                arguments: user); */
                            //  _onEdit(permission);
                            break; */
                          case 1:
                            if (await confirm(context)) {
                              _onDeleteData(context, permission);

                              return print('pressedOK');
                            }
                            return print('pressedCancel');

                          default:
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 10),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Permission Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Text(
                          permission.description,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
/*                     Row(
                      children: [
                        Column(children: [
                          Row(
                            children: [
                              const Text("Readd right?",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child:
                                      checkPermissions(permission.read, "read"))
                            ],
                          )
                        ]),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(children: [
                          Row(
                            children: [
                              const Text("Write right?",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: checkPermissions(
                                      permission.write, "write"))
                            ],
                          )
                        ]),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(children: [
                          Row(
                            children: [
                              const Text("Delete right?",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: checkPermissions(
                                      permission.delete, "delete"))
                            ],
                          )
                        ])
                      ],
                    )
                */
                  ],
                )
              ]),
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

/*   Widget checkPermissions(bool? check, String champs) {
    if (champs == "delete") {
      if (permission.delete!) {
        return Text("yes");
      } else {
        return Text("No");
      }
    }

    if (champs == "write") {
      if (permission.write!) {
        return Text("yes");
      } else {
        return Text("No");
      }
    }

    if (champs == "read") {
      if (permission.read!) {
        return Text("yes");
      } else {
        return Text("No");
      }
    }

    return Text("No");
  } */
}
