import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../../constants/app_theme.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

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
      shadowColor: Colors.blueGrey,
      elevation: 3,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
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
                      Text('Name: ',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    (user.photoURL == null || user.photoURL == "")
                        ? SizedBox(
                            width: 100,
                            height: 100,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/add_image.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )

                        /* CircleAvatar(
                  
                    backgroundImage: FileImage(File(category.imageUrl)),
                    radius: 10,
                    backgroundColor: Colors.white,
                  )  */ /* Image.network(
                    category.imageUrl,
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.cover,
                  ) */
                        : Image.network(
                            user.photoURL!,
                            errorBuilder: (context, exception, stackTrace) {
                              return Container(
                                width: 120,
                                height: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_image.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ) /* SizedBox(
                            width: 100,
                            height: 100,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(product.imageUrl)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ) */
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
}
