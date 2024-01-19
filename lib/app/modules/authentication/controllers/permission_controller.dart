import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../../routes/app_pages.dart';
import '../models/permission_model.dart';
import '../models/role_model.dart';
import '../views/admin/permissions/update_permission_view.dart';
import '../views/admin/roles/update_role_view.dart';

class PermissionController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<Permission> permissions = <Permission>[].obs;
  final List<IconData> iconData = <IconData>[Icons.call, Icons.school];
  final Random r = Random();

  PermissionController() {
    permissionList();
  }

  DatabaseService database = DatabaseService();

  Rx<Permission> permission = Permission(description: '').obs;

  Icon randomIcon2() => Icon(iconData[r.nextInt(iconData.length)]);

  TextEditingController addDescriptionController = TextEditingController();

  RxList<String> roles = <String>[].obs;
  RxString roleSelected = ''.obs;
/* 
  Map checkList = {}.obs; */

  var routeNameSelected = ''.obs;

  List<String> routes =
      AppPages.routes.map((e) => e.name.replaceAll("/", " ")).toList().obs;

  @override
  void onInit() {
    super.onInit();
    permissionList();
    print('>>> PermissionController started');
    roles.bindStream(database.getRolesByName());
  }

  Future<List<Permission>?> getPermissionByRole(Role role) {
    final listPermissions = databaseService.getPermissionByRole(role);
    return listPermissions;
  }

  void permissionList() async {
    permissions.bindStream(database.getPermissions());
  }

/*   List<Permission> getActivePermissions() {
    List<Permission> listPermission = [];

    database.getPermissions().listen((event) {
      listPermission = event;
    });

    return listPermission;
  } */

  void addPermission(Permission permission) async {
    databaseService.addPermission(permission);
    AuthenticationController authController =
        Get.find<AuthenticationController>();
    authController.checkUserRolePermission();
    notifyChildrens();
  }

  void deletePermission(Permission permission) async {
    databaseService.deletePermission(permission);
    AuthenticationController authController =
        Get.find<AuthenticationController>();
    authController.checkUserRolePermission();
    notifyChildrens();
  }

  /* void toUpdatePermissionView(Permission permission) async {
    Get.to(() => UpdatePermissionView(currentPermission: permission));
  }
 */
  /* void editPermission(Permission permission) async {
    databaseService.updatePermission(permission);
  } */
}
