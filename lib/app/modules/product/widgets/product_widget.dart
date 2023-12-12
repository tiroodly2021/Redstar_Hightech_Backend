import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../constants/app_theme.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

import '../../middleware/auth_middleware.dart';
import '../models/product_model.dart';

enum Options { Edit, Delete }

class ProductCard extends StatelessWidget {
  Product product;
  final int index;
  DatabaseService databaseService = DatabaseService();
  ProductController productController;

  ProductCard(
      {Key? key,
      required this.product,
      required this.index,
      required this.productController})
      : super(key: key);

  Future<void> _onDeleteData(BuildContext context, Product product) async {
    if (AuthorizationMiddleware.checkPermission(
        Get.find<AuthenticationController>(),
        Get.find<UserController>(),
        "/product/delete")) {
      print("Check Delete route permission valid");
      productController.deleteProduct(product);
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
  }

  Future<void> _onEdit(Product product) async {
    productController.product.value = product;
    productController.addDescriptionController.text = product.description;
    productController.addNameController.text = product.name;
    productController.categorySelected.value = product.category;
    productController.slideList['price'] = product.price.toDouble();
    productController.slideList['quantity'] = product.quantity.toDouble();
    productController.checkList['isPopular'] = product.isPopular;
    productController.checkList['isRecommended'] = product.isRecommended;
    productController.imageLink.value = product.imageUrl;

    productController.toUpdateProductView(product);
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
                        product.name,
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
                            _onEdit(product);
                            break;
                          case 1:
                            if (await confirm(context)) {
                              _onDeleteData(context, product);

                              return print('pressedOK');
                            }
                            return print('pressedCancel');

                            // databaseService.deleteUser(user);

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
                    product.imageUrl == ""
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
                        : Image.network(product.imageUrl,
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
                    Text(product.description),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Category : " + product.category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(
                          width: 34,
                          height: 20,
                          child: Text(
                            "Price",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 20,
                          child: Slider(
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
                        ),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(
                          width: 34,
                          height: 20,
                          child: Text(
                            "Qty.",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 20,
                          child: Slider(
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
                        ),
                        Text(
                          "${product.quantity.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
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
