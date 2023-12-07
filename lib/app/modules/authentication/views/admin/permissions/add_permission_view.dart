import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
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

class AddPermissionView extends GetView<PermissionController> {
  RoleController roleController = Get.put(RoleController());

  AddPermissionView({Key? key}) : super(key: key) {
    resetFields();
    resetRoleFields();
  }

  void _addPermission(Permission permission) {
    controller.addPermission(permission);
  }

  void _addRole(Role role) {
    roleController.addRole(role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add Permission',
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
          child: Obx(() {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Permission Details",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextFormField(
                      "Description", controller.addDescriptionController),
                  Row(
                    children: [
                      DropDownWidgetList(controller.roles, 'role', 'Role'),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              minimumSize: const Size(65, 44)),
                          onPressed: () {
                            _openPopup(context, roleController);
                          },
                          child: const Icon(Icons.add_circle))
                    ],
                  ),
                  _buildCheckBox("Read?", 'isRead', controller.isRead),
                  _buildCheckBox("Write?", 'isWrite', controller.isWrite),
                  _buildCheckBox("Delete?", 'isDelete', controller.isDelete),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () async {
                          Permission permission = Permission(
                              read: controller.checkList['isRead'] ?? false,
                              write: controller.checkList['isWrite'] ?? false,
                              delete: controller.checkList['isDelete'] ?? false,
                              description:
                                  controller.addDescriptionController.text,
                              role: controller.roleSelected.value);

                          _addPermission(permission);

                          resetFields();

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  )
                ]);
          }),
        ),
      ),
    );
  }

  _openPopup(context, RoleController roleController) {
    Alert(
        context: context,
        title: "NEW ROLE",
        content: Column(
          children: <Widget>[
            _buildTextFormField("Name", roleController.addNameController),
            _buildTextFormField(
                "Description", roleController.addDescriptionController),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.black,
            height: 50,
            onPressed: () async {
              String imageLink = '';

              Role category = Role(
                name: roleController.addNameController.text,
                description: roleController.addDescriptionController.text,
              );

              _addRole(category);

              resetRoleFields();

              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Padding DropDownWidgetList(dropLists, field, label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField(
            iconSize: 20,
            decoration: InputDecoration(labelText: label),
            items: (dropLists as List<String>)
                .map((drop) => DropdownMenuItem(value: drop, child: Text(drop)))
                .toList(),
            onChanged: (value) {
              controller.roleSelected.value = value.toString();
            }),
      ),
    );
  }
  /*  Padding DropDownWidgetList(dropLists, field, label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField(
            value: controller.roleSelected.value != ""
                ? controller.roleSelected.value
                : '',
            iconSize: 20,
            decoration: InputDecoration(labelText: label),
            items: (dropLists as List<String>)
                .map((drop) => DropdownMenuItem(value: drop, child: Text(drop)))
                .toList(),
            onChanged: (value) {
              controller.roleSelected.value = value.toString();

              /*  controller.newUser.update(
                field,
                (_) => value,
                ifAbsent: () => value,
              ); */
            }),
      ),
    );
  } */

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
                controller.checkList
                    .update(name, (_) => value, ifAbsent: () => value);
              }),
        ],
      ),
    );
  }

  void resetFields() {
    controller.addDescriptionController.text = '';
    controller.checkList.clear();
  }

  void resetRoleFields() {
    roleController.addNameController.text = '';
    roleController.addDescriptionController.text = '';
  }
}
