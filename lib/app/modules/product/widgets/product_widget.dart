import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../routes/app_pages.dart';
import '../models/product_model.dart';

enum Options { Edit, Delete }

class ProductCard extends StatelessWidget {
  Product product;
  final int index;
  DatabaseService databaseService = DatabaseService();

  ProductCard({Key? key, required this.product, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();

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
                  product.name,
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
                          Navigator.pushNamed(context, AppPages.EDIT_PRODUCT,
                              arguments: product);
                          break;
                        case 1:
                          //String imageUrl = category.imageUrl;
                          databaseService.deleteProduct(product);

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    (product.imageUrl == null || product.imageUrl == "")
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
                            product.imageUrl,
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
                    Text(product.description),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Category : " + product.category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                /*  SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ), */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const SizedBox(
                          width: 40,
                          child: Text(
                            "Price",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Slider(
                          value: product.price,
                          onChanged: (value) {
                            productController.updateProductPrice(
                                index, product, value);
                          },
                          onChangeEnd: (value) {
                            productController.saveNewProductPrice(
                                product, 'price', value);
                          },
                          min: 0,
                          max: 1000,
                          divisions: 1000,
                          activeColor: Colors.black,
                          inactiveColor: Colors.black12,
                        ),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const SizedBox(
                          width: 40,
                          child: Text(
                            "Qty.",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Slider(
                          value: product.quantity.toDouble(),
                          onChanged: (value) {
                            productController.updateProductQuantity(
                                index, product, value.toInt());
                          },
                          onChangeEnd: (value) {
                            productController.saveNewProductQuantity(
                                product, 'quantity', value.toInt());
                          },
                          min: 0,
                          max: 100,
                          divisions: 100,
                          activeColor: Colors.black,
                          inactiveColor: Colors.black12,
                        ),
                        Text(
                          "${product.quantity.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
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
