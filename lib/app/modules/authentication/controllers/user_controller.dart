import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/update_user.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../../routes/app_pages.dart';
import '../models/device_model.dart';
import '../models/role_model.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<User> users = <User>[].obs;
  RxString titleGame = ''.obs;
  final List<IconData> iconData = <IconData>[Icons.call, Icons.school];

  DatabaseService database = DatabaseService();

  Rx<User> user = User(
      buildNumber: '',
      createdAt: '',
      email: '',
      lastLogin: '',
      name: '',
      roles: {}).obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController iconController = TextEditingController();

  TextEditingController addNameController = TextEditingController();
  TextEditingController addEmailController = TextEditingController();
  TextEditingController addPasswordController = TextEditingController();

  RxList<Role> roles = <Role>[].obs;
  RxString roleSelected = ''.obs;
  RxString imageLink = ''.obs;
  RxString imageLinkTemp = ''.obs;
  Rx<Role> role = Role(description: '', name: '').obs;
  var count = 0.obs;

  RxList<Device> devices = <Device>[].obs;

  @override
  void onInit() {
    super.onInit();
    userList();
  }

  void userList() async {
    count.bindStream(database.getCount('users', 'UserController'));

    users.bindStream(database.getUsers());
    roles.bindStream(database.getRoles());
  }

  Future<List<Device>?> getDeviceByUser(User user) {
    // devices.bindStream(Stream.fromFuture(database.getDeviceByUser(user)));
    final listDevices = databaseService.getDeviceByUser(user);

    return listDevices;
  }

  Future<List<Role>?> getRoleByUser(User user) {
    // devices.bindStream(Stream.fromFuture(database.getDeviceByUser(user)));
    final listRoles = databaseService.getRoleByUser(user);

    return listRoles;
  }

  Role getRoleFromId(String str) {
    role.bindStream(database.getRoleById(str));

    return role.value;
  }

  void addUserRole(User user, Role role) async {
    databaseService.addUserRole(user, role);

    //  print(user.toMap());
  }

  void deleteUser(User user) async {
    print('User to delete');
    databaseService.deleteUser(user);
  }

  void toUpdateUserView(User user) async {
    Get.toNamed(AppPages.UPDATE_USER, arguments: user);
  }

  void editUser(User user) async {
    databaseService.updateUser(user);
  }
}
