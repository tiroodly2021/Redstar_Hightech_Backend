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

import '../../../controllers/permission_controller.dart';
import '../../../controllers/role_controller.dart';
import '../../../models/permission_model.dart';
import '../../../models/role_model.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class ShowRoleView extends GetView<RoleController> {
  Role? role;
  List<Permission> permissions = <Permission>[];
  PermissionController permissionController = Get.put(PermissionController());

  ShowRoleView({Key? key, this.role}) : super(key: key) {
    permissions.addAll(permissionController.permissions.value);
  }

  void _setPermission(Permission permission) {
    controller.setPermission(permission);
  }

  @override
  Widget build(BuildContext context) {
    print(permissions);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add Category',
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
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
                                    role!.description,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  )),
                              SizedBox(
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
                  )
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
