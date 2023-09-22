import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/services/storage_services.dart';

enum Options { Edit, Delete }

class CategoryCard extends StatelessWidget {
  Category category;

  final int index;
  DatabaseService database = DatabaseService();
  StorageService storageService = StorageService();

  CategoryCard({Key? key, required this.category, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find();

    print("Cagegory.image == null" + (category.imageUrl == null).toString());

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
                  category.name,
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
                          Navigator.pushNamed(context, AppPages.EDIT_CATEGORY,
                              arguments: category);
                          break;
                        case 1:
                          String imageUrl = category.imageUrl;
                          database.deleteCategory(category);

                          /*   storageService.storage
                              .ref("product_images/" + imageUrl)
                              .delete();
                         */ /* Navigator.pushNamed(
                              context, AppPages.DELETE_CATEGORY); */

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
            category.imageUrl == null || category.imageUrl == ""
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/no_image.jpg"),
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
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(category.imageUrl)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
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
