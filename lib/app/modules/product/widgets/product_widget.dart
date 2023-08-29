import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';

import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  Product product;

  final int index;

  ProductCard({Key? key, required this.product, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();
    //print(productController.products);
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(product.description),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Text(
                          "Price",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: product.price,
                          onChanged: (value) {
                            productController.updateProductPrice(
                                index, product, value);
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
                        const Text(
                          "Qty.",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: product.quantity.toDouble(),
                          onChanged: (value) {
                            productController.updateProductQuantity(
                                index, product, value.toInt());
                          },
                          min: 0,
                          max: 100,
                          divisions: 100,
                          activeColor: Colors.black,
                          inactiveColor: Colors.black12,
                        ),
                        Text(
                          "${product.quantity.toInt()}",
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
}
