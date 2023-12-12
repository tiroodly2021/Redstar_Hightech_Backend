import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/permission_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/permission_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../models/role_model.dart';
import '../views/admin/roles/update_role_view.dart';

class RoleController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<Role> roles = <Role>[].obs;
  final List<IconData> iconData = <IconData>[Icons.call, Icons.school];
  final Random r = Random();

  DatabaseService database = DatabaseService();

  Rx<Role> role = Role(name: '', description: '').obs;

  Icon randomIcon2() => Icon(iconData[r.nextInt(iconData.length)]);

  TextEditingController addNameController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();

  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    roleList();
  }

  void roleList() async {
    count.bindStream(database.getCount('roles', 'RoleController'));
    roles.bindStream(database.getRoles());
  }

  void addRole(Role role) async {
    databaseService.addRole(role);
  }

  void deleteRole(Role role) async {
    databaseService.deleteRole(role);
  }

  void toUpdateRoleView(Role role) async {
    Get.toNamed(AppPages.UPDATE_ROLE, arguments: role);
  }

  void editRole(Role role) async {
    databaseService.updateRole(role);
  }

  void setPermission(Permission permission) {}

  void updateRolePermissions(int index, Permission permission, Role role,
      String s, bool value, PermissionController permissionController) {
    if (value) {
      role.permissionIds!.add(permission.id!);
    } else {
      role.permissionIds!.remove(permission.id!);
    }
    database.updateRolePermissions(role, s);

    permissionController.permissions[index] = permission;
  }
}
