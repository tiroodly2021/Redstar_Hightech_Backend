import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../constants/app_theme.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

import '../../authentication/controllers/authentication_controller.dart';
import '../../middleware/auth_middleware.dart';
import '../../product/models/product_model.dart';
import '../controllers/category_controller.dart';

enum Options { Edit, Delete }

class CategoryCard extends StatelessWidget {
  Category category;
  final int index;
  //DatabaseService databaseService = DatabaseService();
  CategoryController categoryController;
  List<Product>? productsAssoc;

  CategoryCard(
      {Key? key,
      required this.category,
      required this.index,
      required this.categoryController,
      this.productsAssoc})
      : super(key: key);

  Future<void> _onDeleteData(BuildContext context, Category category) async {
    if (AuthorizationMiddleware.checkPermission(
        Get.find<AuthenticationController>(),
        Get.find<UserController>(),
        "/category/delete")) {
      print("Check Delete route permission valid");
      categoryController.deleteCategory(category);
      //   Navigator.of(context).pop();
    }
    {
      Get.snackbar(
          "Delete product", "You don't have permission to delete product",
          icon: const Icon(Icons.warning_amber),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      print(
        "Check Delete route permission not valid",
      );
    }

    //   Navigator.of(context).pop();
  }

  Future<void> _onEdit(Category category) async {
    categoryController.category.value = category;

    categoryController.addNameController.text = category.name;

    categoryController.imageLink.value = category.imageUrl;

    categoryController.toUpdateCategoryView(category);
  }

  @override
  Widget build(BuildContext context) {
    //final UserController userController = Get.find();

    return Card(
      shadowColor: Colors.blueGrey,
      elevation: 3,
      margin: const EdgeInsets.only(
        top: 10,
      ),
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
                      left: Radius.circular(4), right: Radius.circular(4))),
              // color: Color.fromARGB(255, 232, 234, 239),
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        category.name,
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
                      onSelected: (value) async {
                        int selectedValue = value as int;

                        switch (selectedValue) {
                          case 0:
                            /*  Navigator.pushNamed(context, AppPages.EDIT_USER,
                                arguments: user); */
                            _onEdit(category);
                            break;
                          case 1:
                            if (await confirm(context)) {
                              _onDeleteData(context, category);

                              return print('pressedOK');
                            }
                            return print('pressedCancel');

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
                    category.imageUrl == ""
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 110,
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
                        : Image.network(category.imageUrl,
                            width: MediaQuery.of(context).size.width - 50,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 110,
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
                  children: const [],
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
}
