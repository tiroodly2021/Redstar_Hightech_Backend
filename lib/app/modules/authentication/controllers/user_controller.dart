import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/update_user.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<User> users = <User>[].obs;
  RxString titleGame = ''.obs;
  final List<IconData> iconData = <IconData>[Icons.call, Icons.school];
  final Random r = Random();

  DatabaseService database = DatabaseService();

  Rx<User> user = User(
          buildNumber: '',
          createdAt: '',
          email: '',
          lastLogin: '',
          name: '',
          role: '')
      .obs;

  Icon randomIcon2() => Icon(iconData[r.nextInt(iconData.length)]);

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController iconController = TextEditingController();

  TextEditingController addNameController = TextEditingController();
  TextEditingController addEmailController = TextEditingController();
  TextEditingController addPasswordController = TextEditingController();

  List<String> roles = ["user", "editor", "admin"].obs;
  RxString roleSelected = ''.obs;
  RxString imageLink = ''.obs;
  RxString imageLinkTemp = ''.obs;

  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userList();
  }

  void userList() async {
    count.bindStream(database.getCount('users', 'UserController'));

    users.bindStream(database.getUsers());
  }

  void addUser(User user) async {
    databaseService.addUser(user);

    //  print(user.toMap());
  }

  void deleteUser(User user) async {
    print('User to delete');
    databaseService.deleteUser(user);
  }

  void toUpdateUserView(User user) async {
    Get.to(() => UpdateUserView(
          currentUser: user,
        ));
  }

  void editUser(User user) async {
    databaseService.updateUser(user);
  }
}
