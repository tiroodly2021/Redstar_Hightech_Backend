import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  DatabaseService database = DatabaseService();

  Rx<Permission> permission = Permission(description: '').obs;

  /* bool? get isRead => checkList['isRead'];

  bool? get isWrite => checkList['isWrite'];

  bool? get isDelete => checkList['isDelete'];
 */
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
    roles.bindStream(database.getRolesByName());
  }

  void permissionList() async {
    permissions.bindStream(database.getPermissions());
  }

  void addPermission(Permission permission) async {
    databaseService.addPermission(permission);
  }

  void deletePermission(Permission permission) async {
    print('Permission to delete');
    databaseService.deletePermission(permission);
  }

  /* void toUpdatePermissionView(Permission permission) async {
    Get.to(() => UpdatePermissionView(currentPermission: permission));
  }
 */
  /* void editPermission(Permission permission) async {
    databaseService.updatePermission(permission);
  } */
}
