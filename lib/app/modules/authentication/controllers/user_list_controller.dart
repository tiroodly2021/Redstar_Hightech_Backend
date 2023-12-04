import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/update_user.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../models/user_model.dart';

class UserListController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    userList();
  }

  void userList() async {
    users.bindStream(database.getUsers());
  }

  void addUser(User user) async {
    databaseService.addUser(user);

    //  print(user.toMap());
  }

  void deleteUser(User user) async {
    print('User to delete');
    print(user.toMap());
  }

  void toUpdateUserView() async {
    Get.to(() => UpdateUserView());
  }

  void editUser(User user) async {
    databaseService.updateUser(user);
  }
}
