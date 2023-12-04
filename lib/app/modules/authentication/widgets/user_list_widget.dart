import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_list_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../constants/app_theme.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

enum Options { Edit, Delete }

class UserListCard extends StatelessWidget {
  User user;
  final int index;
  DatabaseService databaseService = DatabaseService();
  UserListController userListController;

  UserListCard(
      {Key? key,
      required this.user,
      required this.index,
      required this.userListController})
      : super(key: key);

  Future<void> _onDeleteData(BuildContext context, User user) async {
    userListController.deleteUser(user);
    //   Navigator.of(context).pop();
  }

  Future<void> _onEdit(User user) async {
    userListController.user.value = user;
    userListController.addEmailController.text = user.email;
    userListController.addNameController.text = user.name;
    userListController.roleSelected.value = user.role;
    userListController.imageLink.value = user.photoURL!;

    userListController.toUpdateUserView();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    return Card(
      shadowColor: Colors.blueGrey,
      elevation: 3,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                      left: const Radius.circular(4),
                      right: const Radius.circular(4))),
              // color: Color.fromARGB(255, 232, 234, 239),
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      offset: const Offset(0.0, 1),
                      itemBuilder: (ctx) => [
                        _buildPopMenuItem(
                            "Edit", Icons.edit, Options.Edit.index),
                        _buildPopMenuItem(
                            "Delete", Icons.remove, Options.Delete.index),
                      ],
                      onSelected: (value) {
                        int selectedValue = value as int;

                        switch (selectedValue) {
                          case 0:
                            /*  Navigator.pushNamed(context, AppPages.EDIT_USER,
                                arguments: user); */
                            _onEdit(user);
                            break;
                          case 1:
                            // databaseService.deleteUser(user);
                            _onDeleteData(context, user);

                            break;

                          default:
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    user.photoURL == ""
                        ? SizedBox(
                            width: 100,
                            height: 100,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Image.network(user.photoURL!,
                            width: 100, height: 100, fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          })
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Role: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.role,
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Email: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.email,
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Created: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(DateTime.parse(user.createdAt)),
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [],
                    ),
                    Row(
                      children: const [],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  PopupMenuItem _buildPopMenuItem(String s, IconData edit, int index) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(s),
        ],
      ),
      value: index,
    );
  }

  @override
  List<Object?> get props => [user, index, databaseService, userListController];
}