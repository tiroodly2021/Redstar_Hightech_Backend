import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/permission_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/show_role_view.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../../../middleware/auth_middleware.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../../../controllers/role_controller.dart';
import '../../../../models/role_model.dart';

import 'package:intl/intl.dart';

enum Options { Edit, Delete }

class RoleCard extends StatelessWidget {
  Role role;
  final int index;
  //DatabaseService databaseService = DatabaseService();
  RoleController roleController;

  RoleCard({
    Key? key,
    required this.role,
    required this.index,
    required this.roleController,
  }) : super(key: key);

  Future<void> _onDeleteData(BuildContext context, Role role) async {
    if (AuthorizationMiddleware.checkPermission(
        Get.find<AuthenticationController>(),
        Get.find<UserController>(),
        "/role/delete")) {
      roleController.deleteRole(role);
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

  Future<void> _onEdit(Role role) async {
    roleController.role.value = role;

    roleController.addNameController.text = role.name;
    roleController.addDescriptionController.text = role.name;

    roleController.toUpdateRoleView(role);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Permission>?> futureListPermission =
        roleController.getPermissionByRole(role);

    return GestureDetector(
      onTap: (() => Get.to(() => ShowRoleView(role: role))),
      child: Card(
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
                          role.name,
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
                              _onEdit(role);
                              break;
                            case 1:
                              if (await confirm(context)) {
                                _onDeleteData(context, role);

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
                                role.description,
                                style: const TextStyle(color: Colors.black54),
                              )),
                        ],
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10, top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: const [
                        SizedBox(
                          //  width: 100,
                          child: Text("Permission: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 150,
                          child: FutureBuilder(
                              future: futureListPermission,
                              builder: (context, snap) {
                                if (snap.hasError) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  List<Permission>? permissions =
                                      snap.data as List<Permission>;

                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: permissions.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              const Text(
                                                "-",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(permissions[index]
                                                  .description),
                                            ],
                                          ),
                                        );
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
              )
            ],
          ),
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
  List<Object?> get props => [role, index, roleController];
}
