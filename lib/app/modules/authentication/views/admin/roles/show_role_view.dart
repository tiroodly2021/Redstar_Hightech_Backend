import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/set_permission_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/update_role_view.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/home/controllers/home_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/services/storage_services.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import '../../../../middleware/auth_middleware.dart';
import '../../../controllers/permission_controller.dart';
import '../../../controllers/role_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/permission_model.dart';
import '../../../models/role_model.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class ShowRoleView extends GetView<RoleController> {
  Role? role;
  List<Permission> permissions = <Permission>[];
  PermissionController permissionController = Get.put(PermissionController());

  ShowRoleView({Key? key, this.role}) : super(key: key) {}

  void _onEdit(Role role) {
    controller.addNameController.text = role.name;
    controller.addDescriptionController.text = role.description;

    controller.toUpdateRoleView(role);
  }

  void _onDelete(context, Role role) async {
    if (await confirm(context)) {
      if (AuthorizationMiddleware.checkPermission(
          Get.find<AuthenticationController>(),
          Get.find<UserController>(),
          "/role/delete")) {
        controller.deleteRole(role);
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

      Get.back();
      return print('pressedOK');
    }

    return print('pressedCancel');
  }

  @override
  Widget build(BuildContext context) {
    permissionController = Get.find<PermissionController>();
    permissions = permissionController.permissions.value;

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Permission Details',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                            left: Radius.circular(4),
                            right: Radius.circular(4))),
                    // color: Color.fromARGB(255, 232, 234, 239),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              role!.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 40),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Role Description",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Text(
                                    role!.description,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  )),
                            ],
                          ),
                          MyDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70,
                                                40),
                                            primary: Colors.black),
                                        onPressed: () async {
                                          _onEdit(role!);
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.edit,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                          MyDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70,
                                                40),
                                            primary: Colors.black),
                                        onPressed: () async {
                                          _onDelete(context, role!);
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                          MyDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70,
                                                40),
                                            primary: Colors.black),
                                        onPressed: () async {
                                          Get.toNamed(AppPages.SET_PERMISSIONS,
                                              arguments: role!);

                                          /*  Get.to(
                                              () => SetPermissionView(
                                                    currentRole: role!,
                                                  ),
                                              routeName:
                                                  AppPages.SET_PERMISSIONS); */
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.perm_data_setting,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Permissions",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),

          /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Role Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                /*  _buildTextFormField("Name", controller.addNameController),
                _buildTextFormField(
                    "Description", controller.addDescriptionController), */
                Text(role!.name),
                const SizedBox(height: 20),
                Row(
                  children: [],
                ),
                const SizedBox(height: 10),
                Text(role!.description),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      onPressed: () async {
                        /*    _setPermissions(role);

                        resetFields();

                        Navigator.pop(context); */
                      },
                      child: const Text(
                        "Set Permissions",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                )
              ]), */
        ),
      ),
    );
  }

  Column MyDivider() {
    return Column(
      children: const [
        SizedBox(
          height: 20,
        ),
        Divider(
          thickness: 2,
          color: Colors.black12,
          height: 2,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
/* 
  Padding _buildTextFormField(
      String hintText, TextEditingController fieldEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: fieldEditingController,
        decoration: InputDecoration(hintText: hintText),
        /* onChanged: (value) {
          controller.newUser.update(name, (_) => value, ifAbsent: () => value);
        }, */
      ),
    );
  }

  void resetFields() {
    controller.addNameController.text = '';
    controller.addDescriptionController.text = '';
  } */
}


/* 

Column(
                      children: [
                        const Text(
                          "Role Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Text(
                                        role!.description,
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black),
                                        onPressed: () async {
                                          /*    _setPermissions(role);

                            resetFields();

                            Navigator.pop(context); */
                                        },
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black),
                                        onPressed: () async {
                                          Get.to(() => UpdateRoleView(
                                                currentRole: role,
                                              ));
                                          /*    _setPermissions(role);

                            resetFields();

                            Navigator.pop(context); */
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black),
                                        onPressed: () async {
                                          Get.to(() => SetPermissionView(
                                              currentRole: role!,
                                              permissionList: permissions));
                                          /*    _setPermissions(role);

                            resetFields();

                            Navigator.pop(context); */
                                        },
                                        child: const Text(
                                          "Permissions",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )
                                ],
                              )
                            ]),
                      ],
                    ),
             

 */