import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/show_role_view.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../../controllers/role_controller.dart';
import '../../../../models/permission_model.dart';
import '../../../../models/role_model.dart';

import 'package:intl/intl.dart';

enum Options { Edit, Delete }

class SetPermissionCard extends StatelessWidget {
  Permission permission;
  Role role;
  final int index;
  //DatabaseService databaseService = DatabaseService();
  /* RoleController roleController; */

  SetPermissionCard(
      {Key? key,
      required this.permission,
      required this.index,
      required this.role})
      : super(key: key);

/*   Future<void> _onDeleteData(BuildContext context, Role role) async {
    roleController.deleteRole(role);
    //   Navigator.of(context).pop();
  } */

/*   Future<void> _onEdit(Role role) async {
    roleController.role.value = role;

    roleController.addNameController.text = role.name;
    roleController.addDescriptionController.text = role.name;

    roleController.toUpdateRoleView(role);
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
                      const Text(
                        "Permission: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
                        _buildPopMenuItem(
                            "Edit", Icons.edit, Options.Edit.index),
                        _buildPopMenuItem(
                            "Delete", Icons.remove, Options.Delete.index),
                      ],
                      onSelected: (value) async {
                        int selectedValue = value as int;

                        switch (selectedValue) {
                          case 0:
                            /*  Navigator.pushNamed(context, AppPages.EDIT_USER,
                                arguments: user); */
                            //    _onEdit(role);
                            break;
                          case 1:
                            if (await confirm(context)) {
                              // _onDeleteData(context, role);

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
            Switch(
              // This bool value toggles the switch.
              value: false,
              activeColor: Colors.red,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
              },
            )
            /*     Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Role Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              permission.description,
                              style: const TextStyle(color: Colors.black54),
                            )),
                      ],
                    )
                  ]),
            ) */
          ],
        ),
      ),
    );
  }

  Padding _buildCheckBox(String label, String name, bool? controllerValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Checkbox(
              value: controllerValue ?? false,
              checkColor: Colors.black,
              activeColor: Colors.black12,
              onChanged: (value) {
                /*     controller.checkList
                    .update(name, (_) => value, ifAbsent: () => value); */
              }),
        ],
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
}
