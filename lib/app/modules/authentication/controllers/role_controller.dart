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
import 'authentication_controller.dart';

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

  Future<List<Permission>?> getPermissionByRole(Role role) {
    final listPermissions = databaseService.getPermissionByRole(role);
    return listPermissions;
  }

  List<Permission>? getPermissionByRoleAsReal(Role role) {
    RxList<Permission> permissionLists = <Permission>[].obs;
    final listPermissions =
        databaseService.getPermissionByRoleAsStream(role).asStream();
    permissionLists.bindStream(listPermissions);

    return permissionLists;
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

  updateRolePermissions(int index, Permission permission, Role role, String s,
      bool value, PermissionController permissionController) {
    if (value) {
      database.addPermissionbyRole(role, permission);
    } else if (!value) {
      database.removePermissionbyRole(role, permission);
    }

    permissionController.permissions[index] = permission;

    Get.find<AuthenticationController>().onInit();
  }

  Future<List<Permission>?> loadPermissionByRole(Role role) {
    return databaseService.getPermissionByRole(role);
  }
}
