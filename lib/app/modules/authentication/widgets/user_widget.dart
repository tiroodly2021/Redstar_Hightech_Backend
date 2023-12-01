import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../../routes/app_pages.dart';

enum Options { Edit, Delete }

class UserCard extends StatelessWidget {
  User user;
  final int index;
  DatabaseService databaseService = DatabaseService();

  UserCard({Key? key, required this.user, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    //print(productController.products);
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
                      _buildPopMenuItem("Edit", Icons.edit, Options.Edit.index),
                      _buildPopMenuItem(
                          "Delete", Icons.remove, Options.Delete.index),
                    ],
                    onSelected: (value) {
                      int selectedValue = value as int;

                      switch (selectedValue) {
                        case 0:
                          /*    Navigator.pushNamed(context, AppPages.EDIT_PRODUCT,
                              arguments: user); */
                          break;
                        case 1:
                          break;

                        default:
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [Text(user.name)],
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                /*  SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ), */
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
}
