import 'package:firebase_storage/firebase_storage.dart';
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
      roles: []).obs;

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

  List<Role> getRoleByUserAsReal(User user) {
    // devices.bindStream(Stream.fromFuture(database.getDeviceByUser(user)));
    RxList<Role> roleLists = <Role>[].obs;

    print("avant bind");
    roleLists.bindStream(databaseService.getRoleByUserASStream(user));

    print('test:   ${roleLists.first}');

    return roleLists;
  }

  Future<Role> getRoleFromId(String str) {
    Future<Role> futureRole = database.getRoleById(str);

    return futureRole;
  }

  void addUserRole(User user, Role role) async {
    /*  print(user.toMap());

    print(
        "***************************************************************************************************");

    print(role.toMap()..addAll({"id": role.id})); */

    databaseService.addUserRole(user, role);

    //  print(user.toMap());
  }

  void deleteUser(User user) async {
    String? imageName = user.photoURL != '' ? user.photoURL : '';

    imageName = imageName!.split("%2F")[1].split("?")[0];

    databaseService.deleteUser(user);

    // Create a reference to the file to delete
    if (imageName != '') {
      final imageRef =
          FirebaseStorage.instance.ref().child("images/${imageName}");
// Delete the file
      await imageRef.delete();
    }
  }

  void toUpdateUserView(User user) async {
    Get.toNamed(AppPages.UPDATE_USER, arguments: user);
  }

  void editUser(User user, Role role) async {
    /*  print(user.toMap());
    print(
        "***********************************************************************");
    if (role != null) {
      print(role.toMap());
    } */

    databaseService.updateUser(user, role);
  }
}
